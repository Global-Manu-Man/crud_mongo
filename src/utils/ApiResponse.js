export class ApiResponse {
  constructor(success, status, data, message = null) {
    this.success = success;
    this.status = status;
    
    if (success) {
      this.data = data;
    } else {
      this.error = { message: message || data };
    }
    
    if (message && success) {
      this.message = message;
    }
  }

  static success(data, status = 200, message = null) {
    return new ApiResponse(true, status, data, message);
  }

  static error(message, status = 500) {
    return new ApiResponse(false, status, message);
  }
}