'use strict';
angular.module('copayApp.services')
  .factory('logHeader', function($log, platformInfo) {
    $log.info('Starting LEOPay v' + window.version + ' #' + window.commitHash);
    $log.info('Client: '+ JSON.stringify(platformInfo) );
    return {};
  });
