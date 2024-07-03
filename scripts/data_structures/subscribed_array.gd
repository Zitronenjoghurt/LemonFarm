# An array where integer identifiers can subscribe on
class_name SubscribedArray
extends Resource

var _subscribers: Array[int] = []

func subscribe(subscriber: int):
	if subscriber not in _subscribers:
		_subscribers.append(subscriber)

func unsubscribe(subscriber: int):
	if subscriber in _subscribers:
		_subscribers.erase(subscriber)

func is_active() -> bool:
	return len(_subscribers) > 0
