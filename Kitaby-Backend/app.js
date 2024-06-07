const express = require('express');
const app = express();
const mongoose = require('mongoose');
const path = require('path');
require('dotenv').config();

// mongoose.connect('mongodb://127.0.0.1:27017/kitaby', {
mongoose.connect('mongodb+srv://lokmane:password123-@cluster-2cp.tkg7i2i.mongodb.net', {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
.then(() => console.log('Connected to db'))
.catch(() => console.log('Not connected to db'));

app.use(express.json());
app.use((req, res, next) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content, Accept, Content-Type, Authorization');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, PATCH, OPTIONS');
    next();
  });

app.use('/images', express.static(path.join(__dirname, 'images')));

const auth=require('./middleware/auth')

const userRoutes = require('./routes/user');
app.use('/api/auth', userRoutes);

const authBib=require('./middleware/authbib')
const bibRoutes = require('./routes/biby');
const bibRouter = require('./routes/bib');
app.use('/api/bib/auth', bibRouter);
app.use('/api/bib/',authBib,bibRoutes)

const profileRoutes = require('./routes/profile');
app.use('/api/profile',profileRoutes);

const forumRoutes = require('./routes/forum');
app.use('/api/forum',forumRoutes);

const messageRoutes=require('./routes/message')
app.use('/api/message/',auth,messageRoutes)

const chatRouter=require('./routes/chat')
app.use('/api/chat/',auth,chatRouter)

const homeRouter=require('./routes/home')
app.use('/api/home',homeRouter)

const adminRouter=require('./routes/admin')
app.use('/api/admin',adminRouter)

const offersRouter=require('./routes/offers')
app.use('/api/offers',auth,offersRouter)

module.exports = app;