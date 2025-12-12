import { Request, User } from '../models/index.js';

export async function listMy(req, res) {
  const where = { requester_id: req.user.id };
  const rows = await Request.findAll({ where, order: [['created_at','DESC']] });
  res.json(rows);
}

export async function createOne(req, res) {
  const { blood_group, urgency, notes } = req.body;
  const row = await Request.create({ blood_group, urgency, notes, requester_id: req.user.id });
  res.status(201).json(row);
}

export async function updateOne(req, res) {
  const { id } = req.params;
  const row = await Request.findByPk(id);
  if (!row || row.requester_id !== req.user.id) return res.status(404).json({ message: 'Not found' });
  const { status, notes } = req.body;
  if (status) row.status = status;
  if (notes) row.notes = notes;
  await row.save();
  res.json(row);
}

export async function removeOne(req, res) {
  const { id } = req.params;
  const row = await Request.findByPk(id);
  if (!row || row.requester_id !== req.user.id) return res.status(404).json({ message: 'Not found' });
  await row.destroy();
  res.json({ ok: true });
}
