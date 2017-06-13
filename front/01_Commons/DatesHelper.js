'use strict';

function DateHelpers() {
}

DateHelpers.prototype.fromDateStringUrlToDate = _fromDateStringUrlToDate;
DateHelpers.prototype.toFrStringFormat = _toFrStringFormat;


/**
 * @function _fromDateStringUrlToDate
 * @desc Format string format dd-MM-YYYY to Date object
 * @param {string} dateString
 * @returns {Date}
 */
function _fromDateStringUrlToDate(dateString) {
    dateString = dateString.replace(new RegExp("/", 'g'), '-');
  var dateReg = /^\d{2}([-])\d{2}\1\d{4}$/,
    dateStringSplitted = null;

  if (!dateString.match(dateReg)) {
    throw new Error('Mauvais format de date.');
  }
  dateStringSplitted = dateString.split('-');
  return new Date(dateStringSplitted[2] + '-' + dateStringSplitted[1] + '-' + dateStringSplitted[0]);
}

/**
 * @function _toFrStringFormat
 * @param {Date} date
 */
function _toFrStringFormat(date) {
  var day = date.getUTCDate(),
    month = date.getUTCMonth() + 1;
  if (day < 10) {
    day = '0' + day;
  }
  if (month < 10) {
    month = '0' + month;
  }
  return day + '/' + month + '/' + date.getFullYear();
}

module.exports = new DateHelpers();