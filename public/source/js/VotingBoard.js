//truncate helper
String.prototype.trunc = function(n){
    return this.substr(0,n-1)+(this.length>n?'...':'');
};

/*
  TopicListItem
  responsible for taking ajax actions and displaying the items data
*/
var TopicListItem = React.createClass({
  //a generic ajax request
  ajaxRequest : function(type, id, action) {
    var url;
    if(action == "delete") {
      url = "//localhost:3000/topics/"+id+".json";
    } else {
      url = "//localhost:3000/topics/"+id+"/"+action;
    }

    $.ajax({
      type : type,
      url : url,
      dataType : "json",
      success : function(){
        votingBoard.loadTopicsFromServer();
      }
    });
  },
  deleteItem : function() {
    console.log("TopicListItem:deleteItem");
    var id = this.props.itemId;
    this.ajaxRequest("DELETE",id,"delete");
  },
  upvoteItem : function() {
    console.log("TopicListItem:upvoteItem");
    var id = this.props.itemId;
    this.ajaxRequest("POST",id,"upvote");
  },
  downvoteItem : function(e) {
    console.log("TopicListItem:downvoteItem");
    var id = this.props.itemId;
    this.ajaxRequest("POST",id,"downvote");
  },
  viewItem : function(){
    console.log("TopicListItem:viewItem");
    viewTopic.setId(this.props.itemId);
  },
  render: function() {
    console.log("TopicListItem:render");
    return (
      <tr>
        <td>
          {this.props.title}
        </td>
        <td>
          {this.props.description.trunc(25)}
        </td>
        <td className="centered">
          {this.props.votes != null ? this.props.votes : 0}
        </td>
        <td className='actions'>
          <a href={"#"+this.props.itemId} className="btn btn-danger" onClick={this.deleteItem}><span className="glyphicon glyphicon-trash"></span></a>&nbsp;
          <a href={"#"+this.props.itemId} className="btn btn-success" onClick={this.upvoteItem}><span className="glyphicon glyphicon-arrow-up"></span></a>&nbsp;
          <a href={"#"+this.props.itemId} className="btn btn-warning" onClick={this.downvoteItem}><span className="glyphicon glyphicon-arrow-down"></span></a>&nbsp;
          <a href={"#"+this.props.itemId} className="btn btn-info" onClick={this.viewItem}><span className="glyphicon glyphicon-zoom-in"></span></a>
        </td>
      </tr>
    )
  }
});

/*
  TopicList
  responsible for sorting and rendering the list
*/
var TopicList = React.createClass({
  render: function() {
    console.log("TopicList:render");
    var sorted = this.props.data.sort(function(a, b) {
      return b.votes - a.votes;
    });
    var topicNodes = sorted.map(function (topic) {
      return (
        <TopicListItem
          title={topic.title}
          description={topic.description}
          itemId={topic.id}
          votes={topic.votes}
          key={topic.id}>
        </TopicListItem>
      );
    });
    return (
      <div>
        <table className="table table-striped table-bordered">
          <tbody>
            <tr>
              <th>Title</th>
              <th>Description</th>
              <th>Votes</th>
              <th>Actions</th>
            </tr>
            {topicNodes}
          </tbody>
        </table>
      </div>
    )
  }
});

/*
  VotingBoard
  responsible for loading the data from the server and if necessary for setting the interval
*/
var VotingBoard = React.createClass({
  //once the component mounted, load from the server
  componentDidMount :function(){
    console.log("VotingBoard:componentDidMount");
    //if we wanted to load at an interval uncomment this line - ideally this would happen via websockets
    //setInterval(this.loadTopicsFromServer, this.props.pollInterval);
    this.loadTopicsFromServer();
  },
  loadTopicsFromServer : function(){
    console.log("VotingBoard:loadTopicsFromServer");
    var scope = this;
    $.ajax({
      url : "//localhost:3000/topics.json",
      dataType : "json",
      success : function(data){
        if(this.state == null) {
          this.setState({
            items : data
          });
        } else {
          this.state.items = data;
          this.forceUpdate();
        }
      }.bind(this),
      error : function(data){
        console.log(data);
      }.bind(this),
    });
  },

  render: function() {
    console.log("VotingBoard:render")
    if(this.state == null) {
      return (
        <div>
          No elements to display
        </div>
      )
    }
    if(typeof(this.state.items) === "object") {
      return (
        <div>
          <TopicList data={this.state.items} />
        </div>
      )
    } else {
      return (
        <div>
          No elements to display
        </div>
      )
    }
  }
});

var votingBoard = ReactDOM.render(
  <VotingBoard pollInterval={500} />,
  document.getElementById('voting-board')
);
