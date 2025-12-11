import express from 'express';
import bodyParser from 'body-parser';
import cors from 'cors';
import { Low } from 'lowdb';
import { JSONFile } from 'lowdb/node';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import { initialCourses } from './courseData.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const DB_FILE = join(__dirname, 'db.json');
const adapter = new JSONFile(DB_FILE);
const db = new Low(adapter, {});

async function initDb() {
    try {
        console.log('Reading database...');
        await db.read();
        console.log('Database read successfully');

        if (!db.data) {
            console.log('Initializing empty database...');
            db.data = { courses: [] };
        }

        if (!db.data.courses || db.data.courses.length === 0) {
            console.log('Loading initial courses...');
            db.data.courses = initialCourses;
            console.log(`Loaded ${initialCourses.length} courses`);
            await db.write();
            console.log('Initial courses saved to database');
        } else {
            console.log(`Database already contains ${db.data.courses.length} courses`);
        }
    } catch (error) {
        console.error('Error initializing database:', error);
        throw error;
    }
}

const app = express();
app.use(cors());
app.use(bodyParser.json());

app.get("/api/courses", async (req, res) => {
    try {
        await db.read();
        const lang = req.query.lang;
        let courses = db.data.courses || [];

        // If lang requested, try to replace title/description from translations
        if (lang) {
            courses = courses.map(c => {
                // if translations exist, prefer them
                if (c.translations && c.translations[lang]) {
                    const t = c.translations[lang];
                    // clone and replace
                    return { ...c, title: t.title || c.title, description: t.description || c.description };
                }
                return c;
            });

            // Optionally persist localized title/description back to db.json
            try {
                db.data.courses = courses;
                await db.write();
                console.log(`Persisted localized titles for lang=${lang}`);
            } catch (e) {
                console.warn('Failed to persist localized titles:', e);
            }
        }

        console.log(`Sending ${courses.length} courses (lang=${lang || 'none'})`);
        res.json(courses);
    } catch (error) {
        console.error('Error fetching courses:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

const PORT = process.env.PORT || 4000;

async function startServer() {
    try {
        await initDb();
        app.listen(PORT, () => {
            console.log(`Server running on http://localhost:${PORT}`);
        });
    } catch (error) {
        console.error('Failed to start server:', error);
        process.exit(1);
    }
}

startServer();