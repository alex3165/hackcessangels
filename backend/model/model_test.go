package model

import (
    "labix.org/v2/mgo"
)

func getTestModel() (*Model, error) {
    m, err := NewModel("localhost", "hackcessangels_model_test")
    m.session.SetSafe(&mgo.Safe{})
    return m, err
}

