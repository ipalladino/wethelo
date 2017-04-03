//truncate helper
String.prototype.trunc = function(n){
    return this.substr(0,n-1)+(this.length>n?'...':'');
};

/*
  PlaceListItem
  responsible for taking ajax actions and displaying the items data
*/
var PlaceListItem = React.createClass({
  //a generic ajax request
  ajaxRequest : function(type, id, action) {
    var url;
    var scope = this;
    if(action == "delete") {
      url = "//localhost:3000/places/"+id+".json";
    } else {
      url = "//localhost:3000/places/"+id+"/"+action;
    }

    if(action == "like" || action == "dislike") {
      url = "//localhost:3000/recommendations/"+id+"/"+action;
    }

    $.ajax({
      type : type,
      url : url,
      dataType : "json",
      success : function(){
        //votingBoard.loadPlacesFromServer();
      }
    }).done(function(r){
      console.log(r);
      //if its: like | dislike | recommend | remove_recommendation - use set state
      if(action == "like" || action == "dislike" || action == "recommend" || action == "remove_recommendation") {
        scope.setState(r);
      } else {
        votingBoard.loadPlacesFromServer();
      }
      userHeaderInfoMobile.getUserFromServer();
      userHeaderInfoDesktop.getUserFromServer();
    }).fail(function(e) {
      console.log(e);
    });
  },
  deleteItem : function() {
    console.log("PlaceListItem:deleteItem");
    var id = this.props.itemId;
    this.ajaxRequest("DELETE",id,"delete");
  },
  recommendPlace : function() {
    console.log("PlaceListItem:recommendPlace");
    var id = this.props.itemId;
    this.ajaxRequest("POST",id,"recommend");
  },
  removeRecommendationFromPlace : function(e) {
    console.log("PlaceListItem:removeRecommendationFromPlace");
    var id = this.props.itemId;
    this.ajaxRequest("POST",id,"remove_recommendation");
  },
  likeRecommendation : function(e) {
    console.log("PlaceListItem:likeRecommendation");
    var id = this.props.itemId;
    this.ajaxRequest("GET",id,"like");
  },
  dislikeRecommendation : function(e) {
    console.log("PlaceListItem:dislikeRecommendation");
    var id = this.props.itemId;
    this.ajaxRequest("GET",id,"dislike");
  },
  viewItem : function(){
    console.log("PlaceListItem:viewItem");
    viewPlace.setId(this.props.itemId);
  },
  userRecommendHTML: function(){
    if(this.state != undefined) {
      //state is set, use state instead of props
      if(this.state.user_recommended) {
        return (<a href={"#"+this.props.itemId} className="btn btn-success" onClick={this.removeRecommendationFromPlace}><span className="glyphicon glyphicon-arrow-up"></span></a>)
      } else {
        return (<a href={"#"+this.props.itemId} className="btn btn-default" onClick={this.recommendPlace}><span className="glyphicon glyphicon-arrow-up"></span></a>)
      }
    } else {
      if(this.props.recByUser) {
        return (<a href={"#"+this.props.itemId} className="btn btn-success" onClick={this.removeRecommendationFromPlace}><span className="glyphicon glyphicon-arrow-up"></span></a>)
      } else {
        return (<a href={"#"+this.props.itemId} className="btn btn-default" onClick={this.recommendPlace}><span className="glyphicon glyphicon-arrow-up"></span></a>)
      }
    }

  },
  userLikedRecommendationHTML : function(){
    if(this.state != undefined) {
      //state is set, use state instead of props
      if(this.state.liked_status == 1) {
        return (
          <div>
            <a href={"#"+this.props.itemId} className="btn btn-success" onClick={this.likeRecommendation}><span className="glyphicon glyphicon-thumbs-up"></span></a>
            <a href={"#"+this.props.itemId} className="btn btn-default" onClick={this.dislikeRecommendation}><span className="glyphicon glyphicon-thumbs-down"></span></a>
          </div>
        )
      } else if(this.state.liked_status == -1){
        return (
          <div>
            <a href={"#"+this.props.itemId} className="btn btn-default" onClick={this.likeRecommendation}><span className="glyphicon glyphicon-thumbs-up"></span></a>
            <a href={"#"+this.props.itemId} className="btn btn-danger" onClick={this.dislikeRecommendation}><span className="glyphicon glyphicon-thumbs-down"></span></a>
          </div>
        )
      } else {
        return (
          <div>
            <a href={"#"+this.props.itemId} className="btn btn-default" onClick={this.likeRecommendation}><span className="glyphicon glyphicon-thumbs-up"></span></a>
            <a href={"#"+this.props.itemId} className="btn btn-default" onClick={this.dislikeRecommendation}><span className="glyphicon glyphicon-thumbs-down"></span></a>
          </div>
        )
      }
    } else {
      if(this.props.likedStatus == 1) {
        return (
          <div>
            <a href={"#"+this.props.itemId} className="btn btn-success" onClick={this.likeRecommendation}><span className="glyphicon glyphicon-thumbs-up"></span></a>
            <a href={"#"+this.props.itemId} className="btn btn-default" onClick={this.dislikeRecommendation}><span className="glyphicon glyphicon-thumbs-down"></span></a>
          </div>
        )
      } else if(this.props.likedStatus == -1){
        return (
          <div>
            <a href={"#"+this.props.itemId} className="btn btn-default" onClick={this.likeRecommendation}><span className="glyphicon glyphicon-thumbs-up"></span></a>
            <a href={"#"+this.props.itemId} className="btn btn-danger" onClick={this.dislikeRecommendation}><span className="glyphicon glyphicon-thumbs-down"></span></a>
          </div>
        )
      } else {
        return (
          <div>
            <a href={"#"+this.props.itemId} className="btn btn-default" onClick={this.likeRecommendation}><span className="glyphicon glyphicon-thumbs-up"></span></a>
            <a href={"#"+this.props.itemId} className="btn btn-default" onClick={this.dislikeRecommendation}><span className="glyphicon glyphicon-thumbs-down"></span></a>
          </div>
        )
      }
    }
  },
  componentDidMount : function(){
    console.log("setup ")
    var currentEl = ReactDOM.findDOMNode(this);
    $(currentEl).find(".reputation").tooltip({
      content : 'Reputation',
      trigger : 'click',
      placement : "left",
      title : "Reputation"
    })

    $(currentEl).find(".recommendations").tooltip({
      content : 'Reputation',
      trigger : 'click',
      placement : "right",
      title : "Recommendations"
    })
  },
  render: function() {
    console.log("PlaceListItem:render");

    var image = ""
    if(this.props.placePictures.length > 0) {
      image = this.props.placePictures[0].image;
    }
    const divStyle = {
      backgroundImage: 'url(' + image + ')',
      backgroundSize: 'cover'
    };

    return (
      <div className="place" style={divStyle}>
        <div className="recommendations">
          {this.props.recommendations != null ? this.props.recommendations : 0}
        </div>
        <div className="reputation" data-toggle="tooltip">
          {this.props.reputation != null ? this.props.reputation : 0}
        </div>
        <div className='properties'>
          <div className="title">
            {this.props.title}
          </div>
          <div className="description">
            {this.props.description.trunc(40)}
          </div>
          <div className="location">
            {this.props.address}
          </div>
          <div className='actions'>
            <a href={"#"+this.props.itemId} className="btn btn-danger" onClick={this.deleteItem}><span className="glyphicon glyphicon-trash"></span></a>&nbsp;
            {this.userRecommendHTML()}&nbsp;
            <a href={"#"+this.props.itemId} className="btn btn-info" onClick={this.viewItem}><span className="glyphicon glyphicon-zoom-in"></span></a>
            {this.userLikedRecommendationHTML()}
          </div>
        </div>
      </div>
    )
  }
});

/*
  PlaceList
  responsible for sorting and rendering the list
*/
var PlaceList = React.createClass({
  render: function() {
    console.log("PlaceList:render");
    var sorted = this.props.data.sort(function(a, b) {
      return b.recommendations - a.recommendations;
    });
    var placeNodes = sorted.map(function (place) {
      return (
        <PlaceListItem
          title={place.title}
          description={place.description}
          itemId={place.id}
          lat={place.lat}
          lng={place.lng}
          address={place.address}
          recommendations={place.recommendations}
          reputation={place.reputation}
          recByUser={place.user_recommended}
          likedStatus={place.liked_status}
          placePictures={place.placepictures}
          key={place.id}>
        </PlaceListItem>
      );
    });
    return (
      <div>
        {placeNodes}
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
    //setInterval(this.loadPlacesFromServer, this.props.pollInterval);
    this.loadPlacesFromServer();
  },
  loadPlacesFromServer : function(){
    console.log("VotingBoard:loadPlacesFromServer");
    var scope = this;
    $.ajax({
      url : "//localhost:3000/places.json",
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
          <PlaceList data={this.state.items} />
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
