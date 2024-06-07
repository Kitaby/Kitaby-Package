const chatModel = require("../models/chat");
const User = require("../models/user");
const Message = require("../models/message");

const createChat = async (req, res) => {
  const { firstId, secondId } = req.body;

  try {
    const chat = await chatModel.findOne({
      members: { $all: [firstId, secondId] },
    });
    if (chat) return res.status(200).json(chat);

    const newChat = new chatModel({
      members: [firstId, secondId],
    });

    const response = await newChat.save();

    res.status(200).json(response);
  } catch (error) {
    console.log(error);
    res.status(400).json(error);
  }
};

const findUserChats = async (req, res) => {
  const userId = req.auth.userId;
  const recipientName = req.query.name;

  try {
    const cs = await chatModel.find({
      members: { $in: [userId] },
    });

    let chats = await Promise.all(
      cs.map(async (c) => {
        const recipientId = c?.members.find((id) => id !== userId);
        const recipient = await User.findById(recipientId, {
          name: 1,
          photo: 1,
        });
        if (recipientName) {
            // Assuming recipient.name is a string and you want to perform a case-insensitive search
            const recipientNameLowerCase = recipient.name.toLowerCase();
            const filterNameLowerCase = recipientName.toLowerCase();
            if (!recipientNameLowerCase.includes(filterNameLowerCase)) {
              return null; // Skip this chat if recipient's name does not match the filter
            }
        }
        let lastMessage = await Message.find(
          { chatId: c._id },
          { text: 1, senderId: 1, createdAt: 1 }
        );
        lastMessage = lastMessage.pop();
        return { c, recipient, lastMessage };
      })
    );
    chats = chats.filter(chat => chat !== null);

    res.status(200).json({ chats });
  } catch (error) {
    console.log(error);
    res.status(400).json(error);
  }
};

const findChat = async (req, res) => {
  const { firstId, secondId } = req.params;

  try {
    const chat = await chatModel.findOne({
      members: { $all: [firstId, secondId] },
    });

    recipient = await User.findById(secondId, { name: 1, photo: 1 });

    return res.status(200).json({ chat, recipient });
  } catch (error) {
    console.log(error);
    res.status(400).json(error);
  }
};



module.exports = {
  findChat,
  createChat,
  findUserChats,
};
