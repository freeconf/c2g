package nodes

import (
	"github.com/c2stack/c2g/node"
	"github.com/c2stack/c2g/val"
)

// Null throws all data away when written to and always returns
// itself for reading, no data for fields
func Null() node.Node {
	n := &Basic{}
	n.OnChild = func(r node.ChildRequest) (node.Node, error) {
		if r.New {
			return n, nil
		}
		return nil, nil
	}
	n.OnNext = func(r node.ListRequest) (node.Node, []val.Value, error) {
		if r.New {
			return n, nil, nil
		}
		return nil, nil, nil
	}
	n.OnField = func(node.FieldRequest, *node.ValueHandle) error {
		return nil
	}
	return n
}