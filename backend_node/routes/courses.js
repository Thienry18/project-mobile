const express = require('express');
const router = express.Router();

// Helper function to localize course data
function localizeCourse(course, lang) {
    const defaultLang = 'en';
    const l = lang || defaultLang;
    return {
        ...course,
        title: typeof course.title === 'object' ? (course.title[l] || course.title[defaultLang]) : course.title,
        description: typeof course.description === 'object' ? (course.description[l] || course.description[defaultLang]) : course.description,
        duration: typeof course.duration === 'object' ? (course.duration[l] || course.duration[defaultLang]) : course.duration,
    };
}

// Get all courses
router.get('/', async (req, res) => {
    try {
        await req.db.read();
        let courses = req.db.data.courses || [];

        const { category, search, lang } = req.query;

        if (category) {
            courses = courses.filter(c =>
                c.category.toLowerCase() === category.toLowerCase()
            );
        }

        if (search) {
            const searchLower = search.toLowerCase();
            courses = courses.filter(c => {
                const localized = localizeCourse(c, lang);
                return localized.title.toLowerCase().includes(searchLower) ||
                    c.category.toLowerCase().includes(searchLower) ||
                    c.instructor.toLowerCase().includes(searchLower);
            });
        }

        // Localize the courses
        courses = courses.map(c => localizeCourse(c, lang));

        res.json(courses);
    } catch (error) {
        res.status(500).json({ error: 'Error fetching courses' });
    }
});

// Get trending top 5 courses
router.get('/trending', async (req, res) => {
    try {
        await req.db.read();
        const courses = req.db.data.courses || [];

        const { lang } = req.query;

        const trending = courses
            .filter(c => c.isBestseller)
            .sort((a, b) => {
                const aRating = parseFloat(a.rating.split(' ')[0]);
                const bRating = parseFloat(b.rating.split(' ')[0]);
                return bRating - aRating;
            })
            .slice(0, 5)
            .map(c => localizeCourse(c, lang));

        res.json(trending);
    } catch (error) {
        res.status(500).json({ error: 'Error fetching trending courses' });
    }
});

// Get recommended courses by category
router.get('/recommended/:category', async (req, res) => {
    try {
        await req.db.read();
        const { category } = req.params;
        const { lang } = req.query;
        const courses = req.db.data.courses || [];

        const recommended = courses
            .filter(c => {
                const localized = localizeCourse(c, lang);
                return localized.title.toLowerCase().includes(category.toLowerCase()) ||
                    c.category.toLowerCase().includes(category.toLowerCase());
            })
            .slice(0, 5)
            .map(c => localizeCourse(c, lang));

        res.json(recommended);
    } catch (error) {
        res.status(500).json({ error: 'Error fetching recommended courses' });
    }
});

// Create a new course
router.post('/', async (req, res) => {
    try {
        await req.db.read();
        const courses = req.db.data.courses || [];

        const newCourse = {
            ...req.body,
            index: courses.length + 1
        };

        courses.push(newCourse);
        req.db.data.courses = courses;
        await req.db.write();

        res.status(201).json(newCourse);
    } catch (error) {
        res.status(500).json({ error: 'Error creating course' });
    }
});

// Update a course
router.put('/:index', async (req, res) => {
    try {
        await req.db.read();
        const { index } = req.params;
        const courses = req.db.data.courses || [];

        const courseIndex = courses.findIndex(c => c.index === parseInt(index));
        if (courseIndex === -1) {
            return res.status(404).json({ error: 'Course not found' });
        }

        courses[courseIndex] = {
            ...courses[courseIndex],
            ...req.body,
            index: parseInt(index)
        };

        req.db.data.courses = courses;
        await req.db.write();

        res.json(courses[courseIndex]);
    } catch (error) {
        res.status(500).json({ error: 'Error updating course' });
    }
});

// Patch a course
router.patch('/:index', async (req, res) => {
    try {
        await req.db.read();
        const { index } = req.params;
        const courses = req.db.data.courses || [];

        const courseIndex = courses.findIndex(c => c.index === parseInt(index));
        if (courseIndex === -1) {
            return res.status(404).json({ error: 'Course not found' });
        }

        courses[courseIndex] = {
            ...courses[courseIndex],
            ...req.body
        };

        req.db.data.courses = courses;
        await req.db.write();

        res.json(courses[courseIndex]);
    } catch (error) {
        res.status(500).json({ error: 'Error patching course' });
    }
});

// Delete a course
router.delete('/:index', async (req, res) => {
    try {
        await req.db.read();
        const { index } = req.params;
        const courses = req.db.data.courses || [];

        const courseIndex = courses.findIndex(c => c.index === parseInt(index));
        if (courseIndex === -1) {
            return res.status(404).json({ error: 'Course not found' });
        }

        courses.splice(courseIndex, 1);
        req.db.data.courses = courses;
        await req.db.write();

        res.json({ message: 'Course deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: 'Error deleting course' });
    }
});

module.exports = router;