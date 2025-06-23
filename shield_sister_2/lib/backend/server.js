//
//
//const express = require('express');
//const http = require('http');
//const { Server } = require('socket.io');
//const cors = require('cors');
//
//const app = express();
//app.use(cors());
//
//const server = http.createServer(app);
//const io = new Server(server, {
//  cors: {
//    origin: '*',
//  },
//});
//
//let users = {}; // userId: { socketId, lat, lon, name }
//
//function calculateDistance(lat1, lon1, lat2, lon2) {
//  const R = 6371; // Earth radius in km
//  const dLat = (lat2 - lat1) * Math.PI / 180;
//  const dLon = (lon2 - lon1) * Math.PI / 180;
//  const a =
//    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
//    Math.cos(lat1 * Math.PI / 180) *
//      Math.cos(lat2 * Math.PI / 180) *
//      Math.sin(dLon / 2) *
//      Math.sin(dLon / 2);
//  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
//  return R * c;
//}
//
//io.on('connection', (socket) => {
//  console.log(`🔌 New user connected: ${socket.id}`);
//
//  socket.on('register', (data) => {
//    // Expected: { userId, lat, lon, name }
//    users[data.userId] = {
//      socketId: socket.id,
//      lat: data.lat,
//      lon: data.lon,
//      name: data.name || 'Anonymous'
//    };
//    console.log(`✅ Registered: ${data.userId} (${data.name})`);
//  });
//
//  socket.on('update_location', (data) => {
//    if (users[data.userId]) {
//      users[data.userId].lat = data.lat;
//      users[data.userId].lon = data.lon;
//    }
//  });
//
//  socket.on('send_alert', (data) => {
//    console.log(`🚨 ALERT from ${data.userId} at (${data.lat}, ${data.lon})`);
//
//    const sender = users[data.userId];
//    if (!sender) return;
//
//    Object.entries(users).forEach(([uid, info]) => {
//      if (uid === data.userId) return;
//
//      const dist = calculateDistance(data.lat, data.lon, info.lat, info.lon);
//      console.log(`📏 Distance to ${uid} = ${dist.toFixed(2)} km`);
//
//      if (dist <= 5) {
//        io.to(info.socketId).emit('receive_alert', {
//          from: data.userId,
//          name: sender.name, // ✅ Send the stored name
//          lat: data.lat,
//          lon: data.lon,
//          distance: dist.toFixed(2),
//        });
//
//        console.log(`📢 Alert sent to ${uid} (${dist.toFixed(2)} km)`);
//      }
//    });
//  });
//
//  socket.on('disconnect', () => {
//    console.log(`❌ User disconnected: ${socket.id}`);
//    for (const [userId, userData] of Object.entries(users)) {
//      if (userData.socketId === socket.id) {
//        delete users[userId];
//        console.log(`🧹 Removed user: ${userId}`);
//        break;
//      }
//    }
//  });
//});
//
//server.listen(3000, () => {
//  console.log('✅ WebSocket server running on http://localhost:3000');
//});


const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const cors = require('cors');

const app = express();
app.use(cors());

const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: '*',
  },
});

// Stores connected users: userId -> { socketId, lat, lon, name }
let users = {};

// Haversine formula to calculate distance between two coordinates
function calculateDistance(lat1, lon1, lat2, lon2) {
  const R = 6371; // Earth radius in km
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * Math.PI / 180) *
    Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

io.on('connection', (socket) => {
  console.log(`🔌 New connection: ${socket.id}`);

  socket.on('register', (data) => {
    // Expected: { userId, lat, lon, name }
    if (!data.userId || !data.lat || !data.lon) {
      console.log('⚠️ Invalid register data');
      return;
    }

    users[data.userId] = {
      socketId: socket.id,
      lat: data.lat,
      lon: data.lon,
      name: data.name || 'Anonymous',
    };

    console.log(`✅ Registered user: ${data.userId} (${users[data.userId].name})`);
  });

  socket.on('update_location', (data) => {
    // Expected: { userId, lat, lon }
    if (users[data.userId]) {
      users[data.userId].lat = data.lat;
      users[data.userId].lon = data.lon;
      console.log(`📍 Updated location for ${data.userId}`);
    }
  });

  socket.on('send_alert', (data) => {
    // Expected: { userId, lat, lon }
    const sender = users[data.userId];
    if (!sender) {
      console.log('❌ Alert from unregistered user');
      return;
    }

    console.log(`🚨 ALERT from ${data.userId} (${sender.name}) at (${data.lat}, ${data.lon})`);

    Object.entries(users).forEach(([uid, info]) => {
      if (uid === data.userId) return; // Don't alert the sender

      const dist = calculateDistance(data.lat, data.lon, info.lat, info.lon);
      console.log(`📏 Distance to ${uid} (${info.name}) = ${dist.toFixed(2)} km`);

      if (dist <= 5) {
        io.to(info.socketId).emit('receive_alert', {
          from: data.userId,
          name: sender.name,
          lat: data.lat,
          lon: data.lon,
          distance: dist.toFixed(2),
          timestamp: new Date().toISOString(),
        });

        console.log(`📢 Alert sent to ${uid} (${info.name})`);
      }
    });
  });

  socket.on('disconnect', () => {
    console.log(`❌ Disconnected: ${socket.id}`);
    for (const [userId, userData] of Object.entries(users)) {
      if (userData.socketId === socket.id) {
        delete users[userId];
        console.log(`🧹 Removed user: ${userId}`);
        break;
      }
    }
  });
});

server.listen(3000, () => {
  console.log('✅ WebSocket server is running at http://localhost:3000');
});
