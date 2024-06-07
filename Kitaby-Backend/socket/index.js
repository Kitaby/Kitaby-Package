const { Server } = require("socket.io");
const jwt = require('jsonwebtoken');


const tokenToId=(t)=>{
  const decodedToken = jwt.verify(t, 'another random useless string');
  const userId = decodedToken.userId;
  console.log(userId)
  return userId
}


const io = new Server({
  cors: {
    origin: "http://localhost:5173/"
  }
});

let onlineUsers = [];
let userChatStatus = {};
io.on("connection", (socket) => {
  console.log("User connected", socket.id);


  socket.on("isInChat", ({ token,members, chatId }) => {
    const userId=tokenToId(token)
    const recipient=members.find(id => id!==userId);
    const recipientChatId = userChatStatus[recipient];
    const isInChat = recipientChatId === chatId;
    console.log("members ",members);
    console.log("userId ",userId);
    console.log("recipient ",recipient);
    console.log("recipientchatID ",recipientChatId);
    socket.emit("isInChatResponse",  isInChat );
  });

  socket.on("addNewUser", (token) => {
    console.log(token);
    const userId=tokenToId(token)
    if (!onlineUsers.some((user) => user.userId === userId)) {
      onlineUsers.push({
        userId,
        socketId: socket.id
      });
    }
    io.emit("getOnlineUsers", onlineUsers);
    console.log('Online users', onlineUsers);
  });

  socket.on("viewChat", ({ token, chatId }) => {
    console.log(chatId);
    const userId=tokenToId(token)
    userChatStatus[userId] = chatId;
    console.log('User' ,userId,' is viewing chat ',chatId);
  });

  socket.on("sendMessage", ({token,message,members}) => {
    const userId=tokenToId(token)
    console.log(members)
    const recipientId=members.find(id => id!==userId);
    const user = onlineUsers.find((user) => user.userId==recipientId);
    console.log("user.id ",userId);
    console.log("recipientId ",recipientId)
    onlineUsers.map((u)=>{
      console.log(u,"uuuu")
    })
    console.log(userChatStatus);
    if (user) {
      const recipientChatId = userChatStatus[recipientId];
      const senderChatId = userChatStatus[userId];
      console.log("li nb3tolah ",user);
      if (recipientChatId === senderChatId) {
        message.status = 'seen';
      } else {
        message.status = 'sent';
      }
      io.to(user.socketId).emit('getMessage', message);
    }
  });

  socket.on('disconnect', () => {
    onlineUsers = onlineUsers.filter((user) => user.socketId !== socket.id);
    console.log("onlineUsers ",onlineUsers)
    io.emit("getOnlineUsers", onlineUsers);

    for (const userId in userChatStatus) {
      if (userChatStatus[userId] === socket.id) {
        delete userChatStatus[userId];
      }
    }
  });

  socket.on('leaveChat', ({ token }) => {
    const userId=token;
    delete userChatStatus[userId];
    console.log('User' ,userId,' left the chat');
  });
});

io.listen(4000);