import { Req, Res } from '../utils/types-routes';
import ClientError from '../utils/client-error';
import { client, sequelize } from '../conn';
import defineUserDb from '../lib/define-user-db';
const jwt = require('jsonwebtoken');
const { User } = require('../model/user-table');
const { authorizeUser } = require('../lib/authorizeUser');

/**
 *
 * Put route that updates data at the table and id of your choice
 * Not all params are required
 * returns updated data
 * @param { string } name
 * @param { string } moveType
 * @param { string } damage
 * @param { string } category
 * @param { string } activeFrames
 * @param { string } totalFrames
 * @param { string } firstFrame
 * @param { string } statValue
 * @param { string } table // fighters, moves, throws, movements, or stats
 * @param { number } id   // fighterId, moveId, throwId, movementId, or statId
 * @return { object }
 */
async function updateTableData(req: Req, res: Res, next: any) {
  const { authorization, username } = req.headers;
  const fullResult = {};
  const { fighter, displayName, name, moveType, damage, category, activeFrames, totalFrames, firstFrame, statValue } = req.body;
  const { rosterId } = req.body;

  try {
    if (/[A-Z]/gi.test(req.params.id) &&
      req.params.id !== undefined) {
      throw new ClientError(400, 'fighterId must be a number');
    }
    const id = Number(req.params.id);
    const userIsTrue = authorization || username;
    const authResult = userIsTrue ? await authorizeUser(authorization, username, next) : null;
    if (!authResult.dataValues) throw new ClientError(authResult.status, authResult.message);
    const { Fighters, Moves, Hitboxes, Throws, Grappling, Movements, Dodging, Stats, Miscellaneous } = defineUserDb(authResult.dataValues.userDB);

    if (req.params.table === 'fighters') {
      if (/[A-Z]/gi.test(rosterId) &&
      rosterId) {
        throw new ClientError(400, 'rosterId must be a number');
      }

      await sequelize.transaction(async (t: any) => {

        const result = await Fighters.findOne({
          where: { fighterId: id }, transaction: t
        });

        if (!result) {
          throw new ClientError(404, `fighterId ${(id)} doesn't exist`);
        }
        const updateResult = await Fighters.update({
          fighter: fighter, displayName: displayName, rosterId: rosterId
        },
        { where: { fighterId: id }, transaction: t });

        if (updateResult[0] === 0) {
          throw new ClientError(400, 'At least one of (fighter), (rosterId), or (displayName) must have a value');
        }
        return res.status(200).json({ message: 'Fighter has been updated successfully', affectedFighterId: result.dataValues.fighterId });
      })

    } else if (req.params.table === 'moves') {
      await sequelize.transaction(async (t: any) => {

        const result = await Moves.findOne({
          where: { moveId: id }, transaction: t
        });

        if (!result) {
          throw new ClientError(404, `(moveId) ${id} doesn't exist`);
        }
        const moves = await Moves.update({
          name: name,
          moveType: moveType,
          category: category
        }, { where: { moveId: id }, transaction: t });

        const hitboxes = await Hitboxes.update({
          activeFrames: activeFrames,
          damage: damage,
          firstFrame: firstFrame,
          totalFrames: totalFrames
        }, { where: { moveId: id }, transaction: t });

        if (moves[0] === 0 && hitboxes[0] === 0) {
          throw new ClientError(400, 'No values were changed');
        }
        return res.status(200).json({ message: 'Moves have been updated successfully', affectedFighterId: result.dataValues.fighterId });
      });

    } else if (req.params.table === 'throws') {
      await sequelize.transaction(async (t: any) => {

        const result = await Throws.findOne({
          where: { throwId: id }, transaction: t
        });
        if (!result) {
          throw new ClientError(404, `(throwId) ${id} doesn't exist`);
        }
        const throws = await Throws.update({
          name: name
        }, { where: { throwId: id }, transaction: t });

        const grappling = await Grappling.update({
          activeFrames: activeFrames, damage: damage, totalFrames
        }, { where: { throwId: id }, transaction: t });

        if(throws[0] === 0 && grappling[0] === 0) {
          throw new ClientError(400, 'No values were changed');
        }
        return res.status(200).json({ message: 'Throws have been updated successfully', affectedFighterId: result.dataValues.fighterId });
      })

    } else if (req.params.table === 'movements') {
      await sequelize.transaction(async (t: any) => {

        const result = await Movements.findOne({
          where: { movementId: id }, transaction: t
        });
        if(!result) {
          throw new ClientError(404, `(movementId) ${id} doesn't exist`);
        }

        const movements = await Movements.update({
          name: name
        }, { where: { movementId: id }, transaction: t});

        const dodging = await Dodging.update({
          activeFrames: activeFrames, totalFrames: totalFrames
        }, { where: { movementId: id }, transaction: t });

        if (movements[0] === 0 && dodging[0] === 0) {
          throw new ClientError(400, 'No values were changed');
        }
        return res.status(200).json({ message: 'Movements have been updated successfully', affectedFighterId: result.dataValues.fighterId });
      });

    } else if (req.params.table === 'stats') {
      await sequelize.transaction(async (t: any) => {

        const result = await Stats.findOne({
          where: { statId: id }, transaction: t
        });

        if (!result) {
          throw new ClientError(404, `(statId) ${id} doesn't exist`);
        }

        const stats = await Stats.update({
          name: name
        }, { where: { statId: id }, transaction: t });

        const miscellaneous = await Miscellaneous.update({
          statValue: statValue
        }, { where: { statId: id }, transaction: t });

        if(stats[0] === 0 && miscellaneous[0] === 0) {
          throw new ClientError(400, 'No values were changed');
        }
        return res.status(200).json({ message: 'Stats have been updated successfully', affectedFighterId: result.dataValues.fighterId });
      });
    } else {
      throw new ClientError(400, `${req.params.table} is not a valid path parameter`);
    }
  } catch (e: any) {
    if (e.name === 'SequelizeUniqueConstraintError') {
      return next(new ClientError(400, e.errors[0].message));
    }
    return next(e);
  }
}

module.exports = {
  updateTableData,
}
