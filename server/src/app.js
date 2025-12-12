import express from 'express';
import helmet from 'helmet';
import cors from 'cors';
import rateLimit from 'express-rate-limit';
import hpp from 'hpp';
import xss from 'xss-clean';
import { createServer } from 'http';
import { Server as SocketIOServer } from 'socket.io';
import YAML from 'yamljs';
import swaggerUI from 'swagger-ui-express';

import router from './routes/index.js';
import { connectDB } from './config/database.js';
import logger from './config/logger.js';
import { Notification, Role, User } from './models/index.js';
import { errorHandler } from './middleware/error.js';

export async function createApp() {
  const app = express();
  app.use(helmet());

  // THIS IS THE ONLY CORS CONFIG THAT 100% WORKS WITH FLUTTER WEB
  app.use(cors({
    origin: true,          // Reflects the incoming origin → always allowed
    credentials: true,     // Important for future cookies / auth headers
  }));

  app.use(rateLimit({ windowMs: 60 * 1000, max: 300 }));
  app.use(hpp());
  // @ts-ignore
  app.use(xss());
  app.use(express.json({ limit: '2mb' }));

  const httpServer = createServer(app);

  // Same fix for Socket.IO
  const io = new SocketIOServer(httpServer, {
    cors: {
      origin: true,
      credentials: true,
    },
  });

  io.on('connection', (socket) => {
    logger.info('Socket connected');
  });

  app.set('io', io);

  const swaggerDoc = YAML.load(new URL('./docs/openapi.yaml', import.meta.url));
  app.use('/docs', swaggerUI.serve, swaggerUI.setup(swaggerDoc));

  app.use('/api', router);  // ← Your routes are under /api
  app.use(errorHandler);

  await connectDB();
  await Role.sync();
  await User.sync();
  await Notification.sync();

  setInterval(async () => {
    const alert = await Notification.create({
      type: 'urgent',
      title: 'O- needed',
      message: 'City Hospital requires O- units',
      blood_group: 'O-',
      location: 'City Hospital',
    });
    io.emit('urgent_alert', alert.toJSON());
  }, 60000);

  return { app, httpServer };
}