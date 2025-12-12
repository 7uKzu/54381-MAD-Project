import { Notification } from '../models/index.js';

export async function urgentList(req, res) {
  const rows = await Notification.findAll({ where: { type: 'urgent' }, order: [['created_at','DESC']], limit: 10 });
  res.json(rows);
}
