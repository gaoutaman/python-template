from myproject import hello


def test_hello():
    assert hello("world") == "hello, world"
