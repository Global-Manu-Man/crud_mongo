import { User } from '../models/User.js';
import { HTTP_STATUS, ERROR_MESSAGES } from '../config/constants.js';
import { ApiResponse } from '../utils/ApiResponse.js';

export const getUsers = async (req, res, next) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;

    const users = await User.find()
      .skip(skip)
      .limit(limit)
      .select('-__v');

    const total = await User.countDocuments();

    return res.status(HTTP_STATUS.OK).json(
      ApiResponse.success({
        users,
        pagination: {
          page,
          limit,
          total,
          pages: Math.ceil(total / limit)
        }
      })
    );
  } catch (error) {
    next(error);
  }
};

export const createUser = async (req, res, next) => {
  try {
    const { email } = req.body;
    
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(HTTP_STATUS.BAD_REQUEST).json(
        ApiResponse.error(ERROR_MESSAGES.EMAIL_EXISTS)
      );
    }

    const user = await User.create(req.body);
    return res.status(HTTP_STATUS.CREATED).json(
      ApiResponse.success(user, HTTP_STATUS.CREATED, 'User created successfully')
    );
  } catch (error) {
    next(error);
  }
};

export const getUserById = async (req, res, next) => {
  try {
    const user = await User.findById(req.params.id).select('-__v');
    if (!user) {
      return res.status(HTTP_STATUS.NOT_FOUND).json(
        ApiResponse.error(ERROR_MESSAGES.USER_NOT_FOUND)
      );
    }
    return res.status(HTTP_STATUS.OK).json(ApiResponse.success(user));
  } catch (error) {
    next(error);
  }
};

export const updateUser = async (req, res, next) => {
  try {
    const { email } = req.body;
    if (email) {
      const existingUser = await User.findOne({ 
        email, 
        _id: { $ne: req.params.id } 
      });
      if (existingUser) {
        return res.status(HTTP_STATUS.BAD_REQUEST).json(
          ApiResponse.error(ERROR_MESSAGES.EMAIL_EXISTS)
        );
      }
    }

    const user = await User.findByIdAndUpdate(
      req.params.id,
      { $set: req.body },
      { new: true, runValidators: true }
    ).select('-__v');

    if (!user) {
      return res.status(HTTP_STATUS.NOT_FOUND).json(
        ApiResponse.error(ERROR_MESSAGES.USER_NOT_FOUND)
      );
    }

    return res.status(HTTP_STATUS.OK).json(
      ApiResponse.success(user, HTTP_STATUS.OK, 'User updated successfully')
    );
  } catch (error) {
    next(error);
  }
};

export const deleteUser = async (req, res, next) => {
  try {
    const user = await User.findByIdAndDelete(req.params.id);
    if (!user) {
      return res.status(HTTP_STATUS.NOT_FOUND).json(
        ApiResponse.error(ERROR_MESSAGES.USER_NOT_FOUND)
      );
    }
    return res.status(HTTP_STATUS.OK).json(
      ApiResponse.success(null, HTTP_STATUS.OK, 'User deleted successfully')
    );
  } catch (error) {
    next(error);
  }
};