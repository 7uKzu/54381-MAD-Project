import { Router } from 'express';
import { authRequired, roleRequired } from '../middleware/auth.js';
import * as Auth from '../controllers/auth.controller.js';
import * as Req from '../controllers/request.controller.js';
import * as Notif from '../controllers/notification.controller.js';

const router = Router();

// THIS MUST COME AFTER const router = Router() AND BEFORE ALL OTHER ROUTES
router.options('*', (req, res) => {
  res.header('Access-Control-Allow-Origin', req.headers.origin || '*');
  res.header('Access-Control-Allow-Methods', 'GET,POST,PUT,DELETE,OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type,Authorization');
  res.header('Access-Control-Allow-Credentials', 'true');
  res.sendStatus(200);
});

// Your normal routes
router.post('/auth/register', Auth.register);
router.post('/auth/login', Auth.login);
router.post('/auth/refresh', Auth.refresh);
router.post('/auth/logout', Auth.logout);

router.get('/requests', authRequired, Req.listMy);
router.post('/requests', authRequired, Req.createOne);
router.put('/requests/:id', authRequired, Req.updateOne);
router.delete('/requests/:id', authRequired, Req.removeOne);

router.get('/notifications/urgent', Notif.urgentList);

export default router;