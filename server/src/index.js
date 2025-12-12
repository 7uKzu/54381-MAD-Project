import 'dotenv/config';
import { createApp } from './app.js';
import logger from './config/logger.js';

const PORT = process.env.PORT || 4000;

const { httpServer } = await createApp();
httpServer.listen(PORT, () => logger.info(`HTTP server listening on :${PORT}`));