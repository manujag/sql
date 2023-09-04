--sudo apt install -y postgresql-plpython3-10
/* in redsfhit
CREATE OR REPLACE LIBRARY pyaes
LANGUAGE plpythonu
FROM 'https://tinyurl.com/redshift-udfs/pyaes.zip?raw=true';
*/

DROP EXTENSION plpython3u CASCADE;
CREATE EXTENSION plpython3u;

CREATE OR REPLACE FUNCTION python_version()
    RETURNS pg_catalog.text AS $BODY$

    import sys
    plpy.info(sys.version)
    plpy.info(sys.path)
    return 'finish'
    $BODY$
LANGUAGE plpython3u VOLATILE SECURITY DEFINER


select python_version();

SELECT VERSION();



DROP SCHEMA udf_enc CASCADE;
CREATE SCHEMA udf_enc;

--- Create UDF
CREATE OR REPLACE FUNCTION udf_enc.aes_encrypt(input VARCHAR(255))
RETURNS VARCHAR STABLE AS $$
  import pyaes
  import binascii
  if input is None:
     return None
  myKey = 'EISAIDKP@W#D$F%G'.encode(encoding="ascii")
  aes=pyaes.AESModeOfOperationCTR(myKey)
  cipher_txt=aes.encrypt(input)
  cipher_txt2=binascii.hexlify(cipher_txt)
  return str(cipher_txt2.decode('utf-8'))
$$ LANGUAGE plpython3u ;


SELECT udf_enc.aes_encrypt('Manoj');


DROP SCHEMA udf_dec CASCADE;
CREATE SCHEMA udf_dec;

--- Create UDF
CREATE OR REPLACE FUNCTION udf_dec.aes_decrypt(encrypted_msg VARCHAR(255))
RETURNS VARCHAR STABLE AS $$
  import pyaes
  import binascii
  if encrypted_msg is None or len(str(encrypted_msg)) == 0:
       return None
  myKey = 'EISAIDKP@W#D$F%G'.encode(encoding="ascii")
  aes = pyaes.AESModeOfOperationCTR(myKey)
  encrypted_msg2=binascii.unhexlify(encrypted_msg)
  decrypted_msg2 = aes.decrypt(encrypted_msg2)
  return str(decrypted_msg2.decode('utf-8'))
$$ LANGUAGE plpython3u ;


SELECT '35121' AS actual, udf_enc.aes_encrypt('35121') AS encrypted_msg, udf_dec.aes_decrypt('ec684cfb19') AS decrypted_msg;
