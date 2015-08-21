crypto = require('crypto')

aesEncrypt = (data, secretKey)->
  cipher = crypto.createCipher('aes-128-ecb', secretKey)
  return cipher.update(data, 'utf8', 'hex') + cipher.final('hex')

aesDecrypt = (data, secretKey)->
  cipher = crypto.createDecipher('aes-128-ecb', secretKey)
  return cipher.update(data, 'hex', 'utf8') + cipher.final('utf8')

diaryEncrypt = (data, secretKey)->
  buf = new Buffer(data,'utf-8').toString('base64')
  return aesEncrypt(buf,secretKey)

diaryDecrypt = (data, secretKey)->
  base64Data = aesDecrypt(data,secretKey)
  return new Buffer(base64Data,'base64').toString('utf-8')

sha1Hash = (clearString) ->
  sha1 = crypto.createHash('sha1');
  sha1.update(clearString)
  return sha1.digest('hex')



encryptUtil = {
  sha1Hash: sha1Hash
  diaryEncrypt:diaryEncrypt
  diaryDecrypt:diaryDecrypt
}

module.exports = encryptUtil