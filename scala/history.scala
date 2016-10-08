
import scala.collection.immutable.MutableList

class Node(myVal: Int, myChildren: MutableList[Node]) {
  private val value: Int = myVal
  private var children: Mutablelist[Node] = myChildren

  def this(myVal: Int) = this(myVal, new MutableList[Node])

  def add(childVal: Int) = {
    val child = Node(childVal)
    children = child :: children
    this
  }

  def find(myVal: Int) = {
    if (value == myVal) this
    else {
      for (child <- children) {
        Node res = child.find(myVal)
        if (res != None) {
          res
        }
      }
      None
    }
  }
}

class Tree() {
  private val root = Node(0)

  def add(parentVal: Int, childVal: Int) = root.find(parentVal).add(childVal)
}

class History extends App{
  var history = Tree()
  history.add(0,1).add(1,2).add(2,3).add(1,4).add(1,5).add(0,6).add(0,7)
}

