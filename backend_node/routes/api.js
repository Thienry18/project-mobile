const express = require('express');
const router = express.Router();

// Get all courses with optional filtering
router.get('/courses', async (req, res) => {
    try {
        await req.db.read();
        let courses = req.db.data.courses || [];

        const { category, search } = req.query;

        if (category) {
            courses = courses.filter(c =>
                c.category.toLowerCase() === category.toLowerCase()
            );
        }

        if (search) {
            const searchLower = search.toLowerCase();
            courses = courses.filter(c =>
                c.title.toLowerCase().includes(searchLower) ||
                c.category.toLowerCase().includes(searchLower) ||
                c.instructor.toLowerCase().includes(searchLower)
            );
        }

        res.json(courses);
    } catch (error) {
        res.status(500).json({ error: 'Error fetching courses' });
    }
});

// Get trending courses (top 5 bestsellers by rating)
router.get('/courses/trending', async (req, res) => {
    try {
        await req.db.read();
        const courses = req.db.data.courses || [];

        const trending = courses
            .filter(c => c.isBestseller)
            .sort((a, b) => {
                const aRating = parseFloat(a.rating.split(' ')[0]);
                const bRating = parseFloat(b.rating.split(' ')[0]);
                return bRating - aRating;
            })
            .slice(0, 5);

        res.json(trending);
    } catch (error) {
        res.status(500).json({ error: 'Error fetching trending courses' });
    }
});

// Get recommended courses by category
router.get('/courses/recommended/:category', async (req, res) => {
    try {
        await req.db.read();
        const { category } = req.params;
        const courses = req.db.data.courses || [];

        const recommended = courses
            .filter(course =>
                course.title.toLowerCase().includes(category.toLowerCase()) ||
                course.category.toLowerCase().includes(category.toLowerCase())
            )
            .slice(0, 5);

        res.json(recommended);
    } catch (error) {
        res.status(500).json({ error: 'Error fetching recommended courses' });
    }
});

// Get a specific course
router.get('/courses/:index', async (req, res) => {
    try {
        await req.db.read();
        const course = req.db.data.courses.find(c => c.index === parseInt(req.params.index));
        if (!course) {
            return res.status(404).json({ error: 'Course not found' });
        }
        res.json(course);
    } catch (error) {
        res.status(500).json({ error: 'Error fetching course' });
    }
});

// Create a new course
router.post('/courses', async (req, res) => {
    try {
        await req.db.read();
        const courses = req.db.data.courses || [];

        const newIndex = courses.length > 0
            ? Math.max(...courses.map(c => c.index)) + 1
            : 1;

        const newCourse = {
            ...req.body,
            index: newIndex,
            isBestseller: req.body.isBestseller || false
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
router.put('/courses/:index', async (req, res) => {
    try {
        await req.db.read();
        const { index } = req.params;
        const courses = req.db.data.courses || [];

        const courseIndex = courses.findIndex(c => c.index === parseInt(index));
        if (courseIndex === -1) {
            return res.status(404).json({ error: 'Course not found' });
        }

        // Preserve the index when updating
        courses[courseIndex] = {
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

// Patch a course (partial update)
router.patch('/courses/:index', async (req, res) => {
    try {
        await req.db.read();
        const { index } = req.params;
        const courses = req.db.data.courses || [];

        const courseIndex = courses.findIndex(c => c.index === parseInt(index));
        if (courseIndex === -1) {
            return res.status(404).json({ error: 'Course not found' });
        }

        // Update only provided fields
        courses[courseIndex] = {
            ...courses[courseIndex],
            ...req.body,
            index: parseInt(index) // Preserve the index
        };

        req.db.data.courses = courses;
        await req.db.write();

        res.json(courses[courseIndex]);
    } catch (error) {
        res.status(500).json({ error: 'Error updating course' });
    }
});

// Delete a course
router.delete('/courses/:index', async (req, res) => {
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