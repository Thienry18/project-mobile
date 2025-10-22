const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { Low, JSONFile } = require('lowdb');
const { nanoid } = require('nanoid');
const path = require('path');

const JWT_SECRET = process.env.JWT_SECRET || 'dev-secret';
const DB_FILE = path.join(__dirname, 'db.json');

const adapter = new JSONFile(DB_FILE);
const db = new Low(adapter);

async function initDb() {
  await db.read();
  db.data ||= { users: [], courses: [] };
  if (!db.data.courses || db.data.courses.length === 0) {
    // seed with some sample courses
    db.data.courses = [
      { id: 1, title: 'Dart & Flutter Basics', price: '49.99', instructor: 'Jane' },
      { id: 2, title: 'Advanced Flutter Animations', price: '59.99', instructor: 'John' },
    ];
  }
  await db.write();
}

initDb();

const app = express();
app.use(cors());
app.use(bodyParser.json());

app.get('/health', (req, res) => res.json({ ok: true }));

// Course endpoints
app.get('/courses', async (req, res) => {
  await db.read();
  const { category, search } = req.query;
  let courses = db.data.courses;
  
  if (category) {
    courses = courses.filter(c => c.category.toLowerCase() === category.toLowerCase());
  }
  if (search) {
    const searchLower = search.toLowerCase();
    courses = courses.filter(c => 
      c.title.toLowerCase().includes(searchLower) || 
      c.description.toLowerCase().includes(searchLower)
    );
  }
  res.json(courses);
});

app.get('/courses/:id', async (req, res) => {
  await db.read();
  const course = db.data.courses.find(c => String(c.id) === String(req.params.id));
  if (!course) return res.status(404).json({ error: 'Course not found' });
  res.json(course);
});

// Cart endpoints
app.get('/cart', authMiddleware, async (req, res) => {
  await db.read();
  const userCart = db.data.carts.filter(item => item.userId === req.user.sub);
  const cartWithDetails = await Promise.all(userCart.map(async item => {
    const course = db.data.courses.find(c => String(c.id) === String(item.courseId));
    return { ...item, course };
  }));
  res.json(cartWithDetails);
});

app.post('/cart', authMiddleware, async (req, res) => {
  const { courseId } = req.body;
  if (!courseId) return res.status(400).json({ error: 'courseId required' });
  
  await db.read();
  const course = db.data.courses.find(c => String(c.id) === String(courseId));
  if (!course) return res.status(404).json({ error: 'Course not found' });
  
  // Check if already in cart
  const existing = db.data.carts.find(item => 
    item.userId === req.user.sub && String(item.courseId) === String(courseId)
  );
  if (existing) return res.status(409).json({ error: 'Already in cart' });
  
  const cartItem = {
    id: nanoid(),
    userId: req.user.sub,
    courseId,
    addedAt: Date.now()
  };
  db.data.carts.push(cartItem);
  await db.write();
  res.json({ ...cartItem, course });
});

app.delete('/cart/:courseId', authMiddleware, async (req, res) => {
  await db.read();
  const idx = db.data.carts.findIndex(item => 
    item.userId === req.user.sub && String(item.courseId) === String(req.params.courseId)
  );
  if (idx === -1) return res.status(404).json({ error: 'Item not found in cart' });
  db.data.carts.splice(idx, 1);
  await db.write();
  res.json({ ok: true });
});

// Mycourses (purchased courses) endpoints
app.get('/mycourses', authMiddleware, async (req, res) => {
  await db.read();
  const userCourses = db.data.mycourses.filter(item => item.userId === req.user.sub);
  const coursesWithDetails = await Promise.all(userCourses.map(async item => {
    const course = db.data.courses.find(c => String(c.id) === String(item.courseId));
    return { ...item, course };
  }));
  res.json(coursesWithDetails);
});

// Notifications endpoints
app.get('/notifications', authMiddleware, async (req, res) => {
  await db.read();
  const notifications = db.data.notifications
    .filter(n => n.userId === req.user.sub)
    .sort((a, b) => b.createdAt - a.createdAt);
  res.json(notifications);
});

app.post('/notifications/read', authMiddleware, async (req, res) => {
  const { notificationId } = req.body;
  if (!notificationId) return res.status(400).json({ error: 'notificationId required' });
  
  await db.read();
  const notification = db.data.notifications.find(n => 
    n.id === notificationId && n.userId === req.user.sub
  );
  if (!notification) return res.status(404).json({ error: 'Notification not found' });
  
  notification.readAt = Date.now();
  await db.write();
  res.json(notification);
});

// Helper function to create user notification
async function createNotification(userId, type, message, meta = {}) {
  const notification = {
    id: nanoid(),
    userId,
    type,
    message,
    meta,
    createdAt: Date.now(),
    readAt: null
  };
  db.data.notifications.push(notification);
  await db.write();
  return notification;
}

// Checkout endpoint - moves courses from cart to mycourses
app.post('/checkout', authMiddleware, async (req, res) => {
  await db.read();
  const userCart = db.data.carts.filter(item => item.userId === req.user.sub);
  if (userCart.length === 0) return res.status(400).json({ error: 'Cart is empty' });
  
  // Move all cart items to mycourses
  const purchases = userCart.map(item => ({
    id: nanoid(),
    userId: req.user.sub,
    courseId: item.courseId,
    purchasedAt: Date.now()
  }));
  
  // Remove from cart
  db.data.carts = db.data.carts.filter(item => item.userId !== req.user.sub);
  // Add to mycourses
  db.data.mycourses.push(...purchases);
  
  // Create purchase notification
  const courseCount = purchases.length;
  await createNotification(
    req.user.sub,
    'purchase_complete',
    `Successfully purchased ${courseCount} ${courseCount === 1 ? 'course' : 'courses'}`,
    { courseCount, purchaseIds: purchases.map(p => p.id) }
  );
  
  await db.write();
  res.json(purchases);
});

// Activities: record user/course actions (add to cart, remove, checkout, view, etc.)
app.post('/activities', authMiddleware, async (req, res) => {
  const { courseId, type, meta } = req.body;
  if (!courseId || !type) return res.status(400).json({ error: 'courseId and type required' });
  await db.read();
  const activity = {
    id: nanoid(),
    courseId,
    type, // e.g., 'add_to_cart', 'remove_from_cart', 'checkout', 'view'
    userId: req.user.sub,
    meta: meta || {},
    createdAt: Date.now(),
  };
  db.data.activities.push(activity);
  await db.write();
  res.json(activity);
});

app.get('/activities', async (req, res) => {
  await db.read();
  const { courseId, userId, type } = req.query;
  let list = db.data.activities || [];
  if (courseId) list = list.filter(a => String(a.courseId) === String(courseId));
  if (userId) list = list.filter(a => String(a.userId) === String(userId));
  if (type) list = list.filter(a => a.type === type);
  // sort desc
  list = list.sort((a, b) => b.createdAt - a.createdAt);
  res.json(list);
});

app.get('/courses/:id/activities', async (req, res) => {
  const id = req.params.id;
  await db.read();
  const list = (db.data.activities || []).filter(a => String(a.courseId) === String(id));
  res.json(list.sort((a, b) => b.createdAt - a.createdAt));
});

app.post('/auth/register', async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) return res.status(400).json({ error: 'email+password required' });
  await db.read();
  const exists = db.data.users.find(u => u.email === email.toLowerCase());
  if (exists) return res.status(409).json({ error: 'Email exists' });
  const hash = await bcrypt.hash(password, 10);
  const user = { id: nanoid(), email: email.toLowerCase(), passwordHash: hash, createdAt: Date.now() };
  db.data.users.push(user);
  await db.write();
  const token = jwt.sign({ sub: user.id, email: user.email }, JWT_SECRET, { expiresIn: '7d' });
  res.json({ token, user: { id: user.id, email: user.email } });
});

app.post('/auth/login', async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) return res.status(400).json({ error: 'email+password required' });
  await db.read();
  const user = db.data.users.find(u => u.email === email.toLowerCase());
  if (!user) return res.status(401).json({ error: 'Invalid credentials' });
  const ok = await bcrypt.compare(password, user.passwordHash);
  if (!ok) return res.status(401).json({ error: 'Invalid credentials' });
  const token = jwt.sign({ sub: user.id, email: user.email }, JWT_SECRET, { expiresIn: '7d' });
  res.json({ token, user: { id: user.id, email: user.email } });
});

function authMiddleware(req, res, next) {
  const auth = req.headers.authorization;
  if (!auth || !auth.startsWith('Bearer ')) return res.status(401).json({ error: 'No token' });
  const token = auth.split(' ')[1];
  try {
    const payload = jwt.verify(token, JWT_SECRET);
    req.user = payload;
    next();
  } catch (e) {
    return res.status(401).json({ error: 'Invalid token' });
  }
}

app.get('/me', authMiddleware, async (req, res) => {
  await db.read();
  const user = db.data.users.find(u => u.id === req.user.sub);
  if (!user) return res.status(404).json({ error: 'User not found' });
  res.json({ id: user.id, email: user.email });
});

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => console.log(`Server listening on port ${PORT}`));
