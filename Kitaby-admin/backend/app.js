const express=require('express')
const app=express()
const path = require('path');
require('dotenv').config()
const cors = require('cors')
//routers (can be grouped in one file )
homeRouter=require('./routes/home')
authRouter=require('./routes/auth')
offersRouter=require('./routes/offers')
profileRouter=require('./routes/profile')
bibRouter=require('./routes/bib')
forumRoutes = require('./routes/forum');
adminRouter = require ('./routes/admin')


const connectDB=require('./db/connect')

app.use(express.json())
app.use(cors())

app.use((req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content, Accept, Content-Type, Authorization');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, PATCH, OPTIONS');
  next();
});
app.use('/images', express.static(path.join(__dirname, 'images')));
app.use('/api/auth',authRouter)
app.use('/api/home',homeRouter)
app.use('/api/offers',offersRouter)
app.use('/api/profile',profileRouter)
app.use('/api/bib/',bibRouter)
app.use('/api/forum',forumRoutes);
app.use('/api/admin', adminRouter);


const port=3000



start =async ()=>{
    try{
        await connectDB(process.env.CONNECTION_STRING)
        app.listen(port,()=>{console.log("start listening")})
    }
    catch(error){
        console.log(error)
    }
   
}

start()



// mongoose.connect('mongodb://127.0.0.1:27017/kitaby', {

