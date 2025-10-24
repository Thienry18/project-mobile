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
    },
    {
        id: 2,
        title: "Machine Learning A-Z: AI, Python & R + ChatGPT Prize [2025]",
        description: "Learn Machine Learning using Python & R",
        instructor: "Kirill Eremenko",
        price: "$36.29",
        duration: "42h 44m",
        category: "Python",
        rating: 4.5,
        isBestseller: true,
        thumbnail: "assets/images/card_image/encrypted.jpeg"
    },
    {
        id: 3,
        title: "The Complete JavaScript Course 2025: From Zero to Expert!",
        description: "Master modern JavaScript from the beginning",
        instructor: "Jonas Schmedtmann",
        price: "$42.99",
        duration: "68h 15m",
        category: "JavaScript",
        rating: 4.8,
        isBestseller: true,
        thumbnail: "assets/images/card_image/javascript_code.jpg"
    },
    {
        id: 4,
        title: "Java Programming Masterclass for Software Developers",
        description: "Learn Java Programming from a professional developer",
        instructor: "Tim Buchalka",
        price: "$34.50",
        duration: "80h 10m",
        category: "Java",
        rating: 4.6,
        isBestseller: false,
        thumbnail: "assets/images/card_image/reactjs_code.jpg"
    },
    {
        id: 5,
        title: "Data Science and Machine Learning Bootcamp with R",
        description: "Learn Data Science with R Programming",
        instructor: "Jose Portilla",
        price: "$39.99",
        duration: "58h 30m",
        category: "R",
        rating: 4.7,
        isBestseller: true,
        thumbnail: "assets/images/card_image/R.jpg"
    }
];

const app = express();
app.use(cors());
app.use(bodyParser.json());

app.get("/api/courses", (req, res) => {
    res.json(courses);
});

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});