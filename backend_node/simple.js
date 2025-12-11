import express from 'express';
import bodyParser from 'body-parser';
import cors from 'cors';

const courses = [
    {
        id: 1,
        title: "100 Days of Code: The Complete Python Pro Bootcamp",
        description: "Master Python with 100 projects in 100 days",
        instructor: "Angela Yu",
        price: "$38.69",
        duration: "55h 21m",
        category: "Python",
        rating: 4.7,
        isBestseller: true,
        thumbnail: "assets/images/card_image/udemy_course.jpg"
    }
];

console.log('Creating Express app...');
const app = express();

console.log('Setting up middleware...');
app.use(cors());
app.use(bodyParser.json());

console.log('Setting up routes...');
app.get("/", (req, res) => {
    console.log('GET / called');
    res.send('Server is running');
});

app.get("/api/courses", (req, res) => {
    console.log('GET /api/courses called');
    res.json(courses);
});

const PORT = 3000;
app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on http://localhost:${PORT}`);
});