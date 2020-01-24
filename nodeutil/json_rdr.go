package nodeutil

import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"strings"

	"github.com/freeconf/yang/node"
	"github.com/freeconf/yang/val"

	"github.com/freeconf/yang/meta"
)

type JSONRdr struct {
	In     io.Reader
	values map[string]interface{}
}

func ReadJSONIO(rdr io.Reader) node.Node {
	jrdr := &JSONRdr{In: rdr}
	return jrdr.Node()
}

func ReadJSON(data string) node.Node {
	rdr := &JSONRdr{In: strings.NewReader(data)}
	return rdr.Node()
}

func (self *JSONRdr) Node() node.Node {
	var err error
	if self.values == nil {
		self.values, err = self.decode()
		if err != nil {
			return node.ErrorNode{Err: err}
		}
	}
	return JsonContainerReader(self.values)
}

func (self *JSONRdr) decode() (map[string]interface{}, error) {
	if self.values == nil {
		d := json.NewDecoder(self.In)
		if err := d.Decode(&self.values); err != nil {
			return nil, err
		}
	}
	return self.values, nil
}

func leafOrLeafListJsonReader(m meta.HasType, data interface{}) (v val.Value, err error) {
	return node.NewValue(m.Type(), data)
}

func JsonListReader(list []interface{}) node.Node {
	s := &Basic{}
	s.OnNext = func(r node.ListRequest) (next node.Node, key []val.Value, err error) {
		key = r.Key
		if r.New {
			panic("Cannot write to JSON reader")
		}
		if len(r.Key) > 0 {
			if r.First {
				keyFields := r.Meta.KeyMeta()
				for i := 0; i < len(list); i++ {
					candidate := list[i].(map[string]interface{})
					if jsonKeyMatches(keyFields, candidate, key) {
						return JsonContainerReader(candidate), r.Key, nil
					}
				}
			}
		} else {
			if r.Row < len(list) {
				container := list[r.Row].(map[string]interface{})
				if len(r.Meta.KeyMeta()) > 0 {
					// TODO: compound keys
					if keyData, hasKey := container[r.Meta.KeyMeta()[0].Ident()]; hasKey {
						// Key may legitimately not exist when inserting new data
						if key, err = node.NewValues(r.Meta.KeyMeta(), keyData); err != nil {
							return nil, nil, err
						}
					}
				}
				return JsonContainerReader(container), key, nil
			}
		}
		return nil, nil, nil
	}
	return s
}

func JsonContainerReader(container map[string]interface{}) node.Node {
	s := &Basic{}
	var divertedList node.Node
	s.OnChoose = func(state node.Selection, choice *meta.Choice) (m *meta.ChoiceCase, err error) {
		// go thru each case and if there are any properties in the data that are not
		// part of the meta, that disqualifies that case and we move onto next case
		// until one case aligns with data.  If no cases align then input in inconclusive
		// i.e. non-discriminating and we should error out.
		for _, kase := range choice.Cases() {
			for _, prop := range kase.DataDefinitions() {
				if _, found := container[prop.Ident()]; found {
					return kase, nil
				}
				// just because you didn't find a property doesnt
				// mean it's invalid, it's only if you don't find any
				// of the properties of a case
			}
		}
		// just because you didn't find any properties of any cases doesn't
		// mean it's invalid, just that *none* of the cases are there.
		return nil, nil
	}
	s.OnChild = func(r node.ChildRequest) (child node.Node, e error) {
		if r.New {
			panic("Cannot write to JSON reader")
		}
		if value, found := container[r.Meta.Ident()]; found {
			if meta.IsList(r.Meta) {
				return JsonListReader(value.([]interface{})), nil
			}
			return JsonContainerReader(value.(map[string]interface{})), nil
		}
		return
	}
	s.OnField = func(r node.FieldRequest, hnd *node.ValueHandle) (err error) {
		if r.Write {
			panic("Cannot write to JSON reader")
		}
		if val, found := container[r.Meta.Ident()]; found {
			hnd.Val, err = leafOrLeafListJsonReader(r.Meta, val)
		}
		return
	}
	s.OnNext = func(r node.ListRequest) (node.Node, []val.Value, error) {
		if divertedList != nil {
			return nil, nil, nil
		}
		// divert to list handler
		foundValues, found := container[r.Meta.Ident()]
		list, ok := foundValues.([]interface{})
		if len(container) != 1 || !found || !ok {
			msg := fmt.Sprintf("Expected { %s: [] }", r.Meta.Ident())
			return nil, nil, errors.New(msg)
		}
		divertedList = JsonListReader(list)
		s.OnNext = divertedList.Next
		return divertedList.Next(r)
	}
	return s
}

func jsonKeyMatches(keyFields []meta.HasType, candidate map[string]interface{}, key []val.Value) bool {
	for i, field := range keyFields {
		if candidate[field.Ident()] != key[i].String() {
			return false
		}
	}
	return true
}