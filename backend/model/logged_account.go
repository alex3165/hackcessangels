package model

import (
	"crypto"
	"crypto/rand"
	_ "crypto/sha512"

	"encoding/hex"
)

type LoggedAccount struct {
	Password string `json:"-"`
	Salt     string `json:"-"`
}

const (
	lengthOfSalt = 60
)

func (la *LoggedAccount) SetPassword(password string) error {
	// Create the salt
	randomBits := make([]byte, lengthOfSalt)
	_, err := rand.Read(randomBits)
	if err != nil {
		return err
	}
	hasher := crypto.SHA512.New()
	hasher.Write(randomBits)
	hash := hasher.Sum(nil)
	la.Salt = hex.EncodeToString(hash)

	passHasher := crypto.SHA512.New()
	passHasher.Write([]byte(password))
	passHasher.Write([]byte(la.Salt))
	passHash := passHasher.Sum(nil)
	la.Password = hex.EncodeToString(passHash)

	return nil
}

func (la *LoggedAccount) VerifyPassword(password string) bool {
	passHasher := crypto.SHA512.New()
	passHasher.Write([]byte(password))
	passHasher.Write([]byte(la.Salt))
	passHash := passHasher.Sum(nil)

	encodedPassword := hex.EncodeToString(passHash)
	return la.Password == encodedPassword
}
