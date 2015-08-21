crypto = require('crypto')

aesEncrypt = (data, secretKey)->
  cipher = crypto.createCipher('aes-128-ecb', secretKey)
  return cipher.update(data, 'utf8', 'hex') + cipher.final('hex')

aesDecrypt = (data, secretKey)->
  cipher = crypto.createDecipher('aes-128-ecb', secretKey)
  return cipher.update(data, 'hex', 'utf8') + cipher.final('utf8')

sha1Hash = (clearString) ->
  sha1 = crypto.createHash('sha1');
  sha1.update(clearString)
  return sha1.digest('hex')


encryptUtil = {
  aesEncrypt: aesEncrypt
  aesDecrypt: aesDecrypt
  sha1Hash: sha1Hash
}

module.exports = encryptUtil