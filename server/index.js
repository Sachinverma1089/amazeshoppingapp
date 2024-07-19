// imports from packages
require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');




//imports from other files

const authRouter=require('./routes/auth.js');
const adminRouter = require('./routes/admin.js');
const productRouter = require('./routes/product.js');
const userRouter = require('./routes/user.js');



//init
const PORT = process.env.PORT || 3000;
const DB = process.env.DB
const app = express();


//middleware   // CLIENT -> middleware SERVER -> CLIENT
app.use(cors());
app.use(express.json());
app.use(bodyParser.json())
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);


//Connections
mongoose
.connect(DB)
.then(()=>{
    console.log("Connection Sunccessful");
})
.catch((e) => {
    console.log(e);
})


app.listen(PORT,"0.0.0.0",()=>{
    console.log(`Server running on http://0.0.0.0:${PORT}`);
})
// localhost