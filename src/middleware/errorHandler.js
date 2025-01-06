import { HTTP_STATUS } from '../config/constants.js';

export const errorHandler = (err, req, res, next) => {
  console.error(err.stack);

  const status = err.status || HTTP_STATUS.INTERNAL_SERVER;
  res.status(status).json({
    success: false,
    error: {
      message: err.message,
      ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
    }
  });
};