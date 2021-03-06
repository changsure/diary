// Generated by CoffeeScript 1.9.2
var $, authFacebookLogin, authWeiboLogin, config, deleteDiary, fetchOceanContext, forgetPassword, localStorage, loginAccount, oceanService, queryDiary, readDiary, registerAccount, removeOceanContext, resetPassword, saveDiary, updateAccount;

$ = window.$;

config = require('./../config');

localStorage = window.localStorage;

registerAccount = function(user, callback) {
  return $.ajax({
    type: "POST",
    url: config.apiResources.userRegister(),
    headers: {
      "Ocean-Auth": window.oceanContext.backServices.user.oceanAuthHeader
    },
    data: user
  }).done(function(response) {
    if ((response.err != null)) {
      return callback(response.err);
    } else {
      return callback();
    }
  });
};

loginAccount = function(user, callback) {
  return $.ajax({
    type: "POST",
    url: config.apiResources.userLogin(),
    headers: {
      "Ocean-Auth": window.oceanContext.backServices.user.oceanAuthHeader
    },
    data: user
  }).done(function(response) {
    if ((response.err != null)) {
      return callback(response.err);
    } else {
      return callback(null, response.entity.accessToken);
    }
  });
};

forgetPassword = function(user, callback) {
  return $.ajax({
    type: "POST",
    url: config.apiResources.forgetPassword(),
    headers: {
      "Ocean-Auth": window.oceanContext.backServices.user.oceanAuthHeader
    },
    data: user
  }).done(function(response) {
    if ((response.err != null)) {
      return callback(response.err);
    } else {
      return callback();
    }
  });
};

resetPassword = function(resetToken, newPassword, callback) {
  return $.ajax({
    type: "PUT",
    url: config.apiResources.resetPassword(),
    headers: {
      "Ocean-Auth": window.oceanContext.backServices.user.oceanAuthHeader
    },
    data: {
      resetToken: resetToken,
      newPassword: newPassword
    }
  }).done(function(response) {
    if ((response.err != null)) {
      return callback(response.err);
    } else {
      return callback();
    }
  });
};

updateAccount = function(user, callback) {
  user.account = window.oceanContext.userInfo.email;
  return $.ajax({
    type: "PUT",
    url: config.apiResources.userUpdate(),
    headers: {
      "Ocean-Auth": window.oceanContext.backServices.user.oceanAuthHeader
    },
    data: user
  }).done(function(response) {
    if ((response.err != null)) {
      return callback(response.err);
    } else {
      return callback(null, response.entity);
    }
  });
};

fetchOceanContext = function(endUserAccessToken, callback) {
  var url;
  if ((endUserAccessToken != null)) {
    url = config.apiResources.getEndUserOceanContext();
  } else {
    url = config.apiResources.getAnonymousOceanContext();
  }
  return $.ajax({
    type: "GET",
    url: url,
    headers: {
      "AccessToken": endUserAccessToken
    }
  }).done(function(response) {
    var oceanContext;
    if ((response.err != null)) {
      return callback(response.err);
    } else {
      oceanContext = response.entity;
      window.oceanContext = oceanContext;
      localStorage.removeItem('oceanContext');
      localStorage.setItem('oceanContext', JSON.stringify(oceanContext));
      return callback();
    }
  });
};

removeOceanContext = function() {
  window.oceanContext = {};
  return localStorage.removeItem('oceanContext');
};

authWeiboLogin = function(code, callback) {
  return $.ajax({
    type: "GET",
    url: config.apiResources.authWeiboLogin(code),
    headers: {
      "Ocean-Auth": window.oceanContext.backServices.weibo.oceanAuthHeader
    }
  }).done(function(response) {
    var ref;
    if ((response.err != null)) {
      return callback(response.err);
    } else {
      return callback(null, (ref = response.entity) != null ? ref.accessToken : void 0);
    }
  });
};

authFacebookLogin = function(code, callback) {
  return $.ajax({
    type: "GET",
    url: config.apiResources.authFacebookLogin(code),
    headers: {
      "Ocean-Auth": window.oceanContext.backServices.facebook.oceanAuthHeader
    }
  }).done(function(response) {
    var ref;
    if ((response.err != null)) {
      return callback(response.err);
    } else {
      return callback(null, (ref = response.entity) != null ? ref.accessToken : void 0);
    }
  });
};

saveDiary = function(_id, diary, callback) {
  if ((_id != null) && _id !== '') {
    return $.ajax({
      type: "PUT",
      url: config.apiResources.diaryCrudAddress(_id, false),
      headers: {
        "Ocean-Auth": window.oceanContext.backServices.crud.oceanAuthHeader
      },
      data: diary
    }).done(function(response) {
      if ((response.err != null)) {
        return callback(response.err);
      } else {
        return callback(null, response.entity);
      }
    });
  } else {
    return $.ajax({
      type: "POST",
      url: config.apiResources.diaryCrudAddress(_id, false),
      headers: {
        "Ocean-Auth": window.oceanContext.backServices.crud.oceanAuthHeader
      },
      data: diary
    }).done(function(response) {
      if ((response.err != null)) {
        return callback(response.err);
      } else {
        return callback(null, response.entity);
      }
    });
  }
};

readDiary = function(_id, callback) {
  return $.ajax({
    type: "GET",
    url: config.apiResources.diaryCrudAddress(_id, false),
    headers: {
      "Ocean-Auth": window.oceanContext.backServices.crud.oceanAuthHeader
    }
  }).done(function(response) {
    if ((response.err != null)) {
      return callback(response.err);
    } else {
      return callback(null, response.entity);
    }
  });
};

deleteDiary = function(_id, callback) {
  return $.ajax({
    type: "DELETE",
    url: config.apiResources.diaryCrudAddress(_id, false),
    headers: {
      "Ocean-Auth": window.oceanContext.backServices.crud.oceanAuthHeader
    }
  }).done(function(response) {
    if ((response.err != null)) {
      return callback(response.err);
    } else {
      return callback();
    }
  });
};

queryDiary = function(criteria, returnColumn, rowDes, callback) {
  var queryData;
  queryData = {
    criteria: criteria,
    returnColumn: returnColumn,
    rowDes: rowDes
  };
  return $.ajax({
    type: "POST",
    url: config.apiResources.diaryCrudAddress(null, true),
    contentType: 'application/json; charset=UTF-8',
    headers: {
      "Ocean-Auth": window.oceanContext.backServices.crud.oceanAuthHeader
    },
    dataType: 'json',
    data: JSON.stringify(queryData)
  }).done(function(response) {
    if ((response.err != null)) {
      return callback(response.err);
    } else {
      return callback(null, response.entities);
    }
  });
};

oceanService = {
  registerAccount: registerAccount,
  loginAccount: loginAccount,
  updateAccount: updateAccount,
  forgetPassword: forgetPassword,
  resetPassword: resetPassword,
  fetchOceanContext: fetchOceanContext,
  removeOceanContext: removeOceanContext,
  saveDiary: saveDiary,
  readDiary: readDiary,
  deleteDiary: deleteDiary,
  queryDiary: queryDiary
};

module.exports = oceanService;
