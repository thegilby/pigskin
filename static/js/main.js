$(function() {
  var teams = {
    "buf":{"name":"Buffalo Bills","username":"buffalobills","color":"#194B8C","followers":124222,"conf":"AFC"},
    "mia":{"name":"Miami Dolphins","username":"MiamiDolphins","color":"#007883","followers":174389,"conf":"AFC"},
    "ne":{"name":"New England Patriots","username":"Patriots","color":"#243E82","followers":461278,"conf":"AFC"},
    "nyj":{"name":"New York Jets","username":"nyjets","color":"#16452D","followers":488964,"conf":"AFC"},
    "bal":{"name":"Baltimore Ravens","username":"Ravens","color":"#31196B","followers":201777,"conf":"AFC"},
    "cin":{"name":"Cincinatti Bengals","username":"Bengals","color":"#F05737","followers":126695,"conf":"AFC"},
    "cle":{"name":"Cleveland Browns","username":"OfficialBrowns","color":"#ED7E11","followers":122127,"conf":"AFC"},
    "pit":{"name":"Pittsburgh Steelers","username":"steelers","color":"#000","followers":434141,"conf":"AFC"},
    "hou":{"name":"Houston Texans","username":"HoustonTexans","color":"#BF093A","followers":170407,"conf":"AFC"},
    "ind":{"name":"Indianapolis Colts","username":"nflcolts","color":"#24396A","followers":115393,"conf":"AFC"},
    "jac":{"name":"Jacksonville Jaguars","username":"jaguars","color":"#007B92","followers":57257,"conf":"AFC"},
    "ten":{"name":"Tennessee Titans","username":"tennesseetitans","color":"#689DC9","followers":103970,"conf":"AFC"},
    "den":{"name":"Denver Broncos","username":"Denver_Broncos","color":"#004","followers":205957,"conf":"AFC"},
    "kc":{"name":"Kansas City Chiefs","username":"kcchiefs","color":"#CE0226","followers":117664,"conf":"AFC"},
    "oak":{"name":"Oakland Raiders","username":"RAIDERS","color":"#000","followers":208378,"conf":"AFC"},
    "sd":{"name":"San Diego Chargers","username":"chargers","color":"#04284F","followers":172678,"conf":"AFC"},
    "dal":{"name":"Dallas Cowboys","username":"dallascowboys","color":"#162859","followers":450205,"conf":"NFC"},
    "nyg":{"name":"New York Giants","username":"Giants","color":"#03497F","followers":387469,"conf":"NFC"},
    "phi":{"name":"Philadelphia Eagles","username":"Eagles","color":"#004149","followers":243539,"conf":"NFC"},
    "was":{"name":"Washington Redskins","username":"Redskins","color":"#79002E","followers":148156,"conf":"NFC"},
    "chi":{"name":"Chicago Bears","username":"ChicagoBears","color":"#061E3E","followers":226022,"conf":"NFC"},
    "det":{"name":"Detroit Lions","username":"DetroitLionsNFL","color":"#0069B3","followers":178627,"conf":"NFC"},
    "gb":{"name":"Green Bay Packers","username":"packers","color":"#003B2A","followers":364541,"conf":"NFC"},
    "min":{"name":"Minnesota Vikings","username":"VikingsFootball","color":"#360651","followers":158473,"conf":"NFC"},
    "atl":{"name":"Atlanta Falcons","username":"Atlanta_Falcons","color":"#000","followers":154376,"conf":"NFC"},
    "car":{"name":"Carolina Panthers","username":"Panthers","color":"#009FD7","followers":125921,"conf":"NFC"},
    "no":{"name":"New Orleans Saints","username":"Saints","color":"#C9B074","followers":259879,"conf":"NFC"},
    "tb":{"name":"Tampa Bay Buccaneers","username":"TBBuccaneers","color":"#BF093A","followers":88053,"conf":"NFC"},
    "ari":{"name":"Arizona Cardinals","username":"AZCardinals","color":"#A1003E","followers":36238,"conf":"NFC"},
    "stl":{"name":"Saint Louis Rams","username":"STLouisRams","color":"#001945","followers":85934,"conf":"NFC"},
    "sf":{"name":"San Francisco 49ers","username":"49ers","color":"#A1003E","followers":261629,"conf":"NFC"},
    "sea":{"name":"Seattle Seahawks","username":"Seahawks","color":"#3C5179","followers":134746,"conf":"NFC"}
  },
    matchups = {
      "7":{
      "ten_buf":{"date":"Sun Oct 21","start":"10:00:00","away":"ten","home":"buf","awayScore":35,"homeScore":34,"stadium":"Ralph Wilson Stadium"},
      "cle_ind":{"date":"Sun Oct 21","start":"10:00:00","away":"cle","home":"ind","awayScore":13,"homeScore":17,"stadium":"Lucas Oil Stadium"},
      "bal_hou":{"date":"Sun Oct 21","start":"10:00:00","away":"bal","home":"hou","awayScore":13,"homeScore":43,"stadium":"Reliant Stadium"},
      "gb_stl":{"date":"Sun Oct 21","start":"10:00:00","away":"gb","home":"stl","awayScore":30,"homeScore":20,"stadium":"Edward Jones Dome"},
      "no_tb":{"date":"Sun Oct 21","start":"10:00:00","away":"no","home":"tb","awayScore":35,"homeScore":28,"stadium":"Raymond James Stadium"},
      "dal_car":{"date":"Sun Oct 21","start":"10:00:00","away":"dal","home":"car","awayScore":19,"homeScore":14,"stadium":"Bank of America Stadium"},
      "ari_min":{"date":"Sun Oct 21","start":"10:00:00","away":"ari","home":"min","awayScore":14,"homeScore":21,"stadium":"Mall of America Field at H.H.H. Metrodome"},
      "was_nyg":{"date":"Sun Oct 21","start":"10:00:00","away":"was","home":"nyg","awayScore":23,"homeScore":27,"stadium":"MetLife Stadium"},
      "nyj_ne":{"date":"Sun Oct 21","start":"13:25:00","away":"nyj","home":"ne","awayScore":26,"homeScore":29,"stadium":"Gillette Stadium"},
      "jac_oak":{"date":"Sun Oct 21","start":"13:25:00","away":"jac","home":"oak","awayScore":23,"homeScore":26,"stadium":"O.co Coliseum"},
      "pit_cin":{"date":"Sun Oct 21","start":"17:20:00","away":"pit","home":"cin","awayScore":24,"homeScore":17,"stadium":"Paul Brown Stadium"}
      },

      "8":{
      "was_pit":{"date":"Sun Oct 28","start":"10:00:00","away":"was","home":"pit","awayScore":12,"homeScore":27,"stadium":"Heinz Field"},
      "sea_det":{"date":"Sun Oct 28","start":"10:00:00","away":"sea","home":"det","awayScore":24,"homeScore":28,"stadium":"Ford Field"},
      "car_chi":{"date":"Sun Oct 28","start":"10:00:00","away":"car","home":"chi","awayScore":22,"homeScore":23,"stadium":"Soldier Field"},
      "atl_phi":{"date":"Sun Oct 28","start":"10:00:00","away":"atl","home":"phi","awayScore":30,"homeScore":17,"stadium":"Lincoln Financial Field"},
      "ne_stl":{"date":"Sun Oct 28","start":"10:00:00","away":"ne","home":"stl","awayScore":14,"homeScore":34,"stadium":"Wembley Stadium"},
      "ind_ten":{"date":"Sun Oct 28","start":"10:00:00","away":"ind","home":"ten","awayScore":19,"homeScore":13,"stadium":"LP Field"},
      "sd_cle":{"date":"Sun Oct 28","start":"10:00:00","away":"sd","home":"cle","awayScore":6,"homeScore":7,"stadium":"Cleveland Browns Stadium"},
      "mia_nyj":{"date":"Sun Oct 28","start":"10:00:00","away":"mia","home":"nyj","awayScore":30,"homeScore":9,"stadium":"MetLife Stadium"},
      "jac_gb":{"date":"Sun Oct 28","start":"10:00:00","away":"jac","home":"gb","awayScore":15,"homeScore":24,"stadium":"Lambeau Field"},
      "oak_kc":{"date":"Sun Oct 28","start":"13:05:00","away":"oak","home":"kc","awayScore":26,"homeScore":16,"stadium":"Arrowhead Stadium"},
      "nyg_dal":{"date":"Sun Oct 28","start":"13:25:00","away":"nyg","home":"dal","awayScore":29,"homeScore":24,"stadium":"Cowboys Stadium"},
      "no_den":{"date":"Sun Oct 28","start":"17:20:00","away":"no","home":"den","awayScore":14,"homeScore":34,"stadium":"Sports Authority Field at Mile High"}
      },

      "9":{
      "mia_ind":{"date":"Sun Nov 4","start":"10:00:00","away":"mia","home":"ind","awayScore":20,"homeScore":23,"stadium":"Lucas Oil Stadium"},
      "buf_hou":{"date":"Sun Nov 4","start":"10:00:00","away":"buf","home":"hou","awayScore":9,"homeScore":21,"stadium":"Reliant Stadium"},
      "bal_cle":{"date":"Sun Nov 4","start":"10:00:00","away":"bal","home":"cle","awayScore":25,"homeScore":15,"stadium":"Cleveland Browns Stadium"},
      "den_cin":{"date":"Sun Nov 4","start":"10:00:00","away":"den","home":"cin","awayScore":31,"homeScore":23,"stadium":"Paul Brown Stadium"},
      "chi_ten":{"date":"Sun Nov 4","start":"10:00:00","away":"chi","home":"ten","awayScore":51,"homeScore":20,"stadium":"LP Field"},
      "det_jac":{"date":"Sun Nov 4","start":"10:00:00","away":"det","home":"jac","awayScore":31,"homeScore":14,"stadium":"EverBank Field"},
      "ari_gb":{"date":"Sun Nov 4","start":"10:00:00","away":"ari","home":"gb","awayScore":17,"homeScore":31,"stadium":"Lambeau Field"},
      "car_was":{"date":"Sun Nov 4","start":"10:00:00","away":"car","home":"was","awayScore":21,"homeScore":13,"stadium":"FedEx Field"},
      "min_sea":{"date":"Sun Nov 4","start":"13:05:00","away":"min","home":"sea","awayScore":20,"homeScore":30,"stadium":"CenturyLink Field"},
      "tb_oak":{"date":"Sun Nov 4","start":"13:05:00","away":"tb","home":"oak","awayScore":42,"homeScore":32,"stadium":"O.co Coliseum"},
      "pit_nyg":{"date":"Sun Nov 4","start":"13:25:00","away":"pit","home":"nyg","awayScore":24,"homeScore":20,"stadium":"MetLife Stadium"},
      "dal_atl":{"date":"Sun Nov 4","start":"17:20:00","away":"dal","home":"atl","awayScore":13,"homeScore":19,"stadium":"Georgia Dome"}
      },

      "10":{
      "det_min":{"date":"Sun Nov 11","start":"10:00:00","away":"det","home":"min","awayScore":24,"homeScore":34,"stadium":"Mall of America Field at H.H.H. Metrodome"},
      "atl_no":{"date":"Sun Nov 11","start":"10:00:00","away":"atl","home":"no","awayScore":27,"homeScore":31,"stadium":"Mercedes-Benz Superdome"},
      "nyg_cin":{"date":"Sun Nov 11","start":"10:00:00","away":"nyg","home":"cin","awayScore":13,"homeScore":31,"stadium":"Paul Brown Stadium"},
      "oak_bal":{"date":"Sun Nov 11","start":"10:00:00","away":"oak","home":"bal","awayScore":20,"homeScore":55,"stadium":"M&T Bank Stadium"},
      "buf_ne":{"date":"Sun Nov 11","start":"10:00:00","away":"buf","home":"ne","awayScore":31,"homeScore":37,"stadium":"Gillette Stadium"},
      "ten_mia":{"date":"Sun Nov 11","start":"10:00:00","away":"ten","home":"mia","awayScore":37,"homeScore":3,"stadium":"Sun Life Stadium"},
      "sd_tb":{"date":"Sun Nov 11","start":"10:00:00","away":"sd","home":"tb","awayScore":24,"homeScore":34,"stadium":"Raymond James Stadium"},
      "den_car":{"date":"Sun Nov 11","start":"10:00:00","away":"den","home":"car","awayScore":36,"homeScore":14,"stadium":"Bank of America Stadium"},
      "nyj_sea":{"date":"Sun Nov 11","start":"13:05:00","away":"nyj","home":"sea","awayScore":7,"homeScore":28,"stadium":"CenturyLink Field"},
      "dal_phi":{"date":"Sun Nov 11","start":"13:25:00","away":"dal","home":"phi","awayScore":38,"homeScore":23,"stadium":"Lincoln Financial Field"},
      "stl_sf":{"date":"Sun Nov 11","start":"13:25:00","away":"stl","home":"sf","awayScore":24,"homeScore":24,"stadium":"Candlestick Park"},
      "hou_chi":{"date":"Sun Nov 11","start":"17:20:00","away":"hou","home":"chi","awayScore":13,"homeScore":6,"stadium":"Soldier Field"}
      },

      "11":{
      "cin_kc":{"date":"Sun Nov 18","start":"10:00:00","away":"cin","home":"kc","awayScore":28,"homeScore":6,"stadium":"Arrowhead Stadium"},
      "jac_hou":{"date":"Sun Nov 18","start":"10:00:00","away":"jac","home":"hou","awayScore":37,"homeScore":43,"stadium":"Reliant Stadium"},
      "nyj_stl":{"date":"Sun Nov 18","start":"10:00:00","away":"nyj","home":"stl","awayScore":27,"homeScore":13,"stadium":"Edward Jones Dome"},
      "cle_dal":{"date":"Sun Nov 18","start":"10:00:00","away":"cle","home":"dal","awayScore":20,"homeScore":23,"stadium":"Cowboys Stadium"},
      "tb_car":{"date":"Sun Nov 18","start":"10:00:00","away":"tb","home":"car","awayScore":27,"homeScore":21,"stadium":"Bank of America Stadium"},
      "ari_atl":{"date":"Sun Nov 18","start":"10:00:00","away":"ari","home":"atl","awayScore":19,"homeScore":23,"stadium":"Georgia Dome"},
      "gb_det":{"date":"Sun Nov 18","start":"10:00:00","away":"gb","home":"det","awayScore":24,"homeScore":20,"stadium":"Ford Field"},
      "phi_was":{"date":"Sun Nov 18","start":"10:00:00","away":"phi","home":"was","awayScore":6,"homeScore":31,"stadium":"FedEx Field"},
      "no_oak":{"date":"Sun Nov 18","start":"13:05:00","away":"no","home":"oak","awayScore":38,"homeScore":17,"stadium":"O.co Coliseum"},
      "sd_den":{"date":"Sun Nov 18","start":"13:25:00","away":"sd","home":"den","awayScore":23,"homeScore":30,"stadium":"Sports Authority Field at Mile High"},
      "ind_ne":{"date":"Sun Nov 18","start":"13:25:00","away":"ind","home":"ne","awayScore":24,"homeScore":59,"stadium":"Gillette Stadium"},
      "bal_pit":{"date":"Sun Nov 18","start":"17:20:00","away":"bal","home":"pit","awayScore":13,"homeScore":10,"stadium":"Heinz Field"}
      },

      "12":{
      "sea_mia":{"date":"Sun Nov 25","start":"10:00:00","away":"sea","home":"mia","awayScore":21,"homeScore":24,"stadium":"Sun Life Stadium"},
      "atl_tb" :{"date":"Sun Nov 25","start":"10:00:00","away":"atl","home":"tb","awayScore":24,"homeScore":23,"stadium":"Raymond James Stadium"},
      "min_chi":{"date":"Sun Nov 25","start":"10:00:00","away":"min","home":"chi","awayScore":10,"homeScore":28,"stadium":"Soldier Field"},
      "den_kc" :{"date":"Sun Nov 25","start":"10:00:00","away":"den","home":"kc","awayScore":17,"homeScore":9,"stadium":"Arrowhead Stadium"},
      "ten_jac":{"date":"Sun Nov 25","start":"10:00:00","away":"ten","home":"jac","awayScore":19,"homeScore":24,"stadium":"EverBank Field"},
      "buf_ind":{"date":"Sun Nov 25","start":"10:00:00","away":"buf","home":"ind","awayScore":13,"homeScore":20,"stadium":"Lucas Oil Stadium"},
      "pit_cle":{"date":"Sun Nov 25","start":"10:00:00","away":"pit","home":"cle","awayScore":14,"homeScore":20,"stadium":"Cleveland Browns Stadium"},
      "oak_cin":{"date":"Sun Nov 25","start":"10:00:00","away":"oak","home":"cin","awayScore":10,"homeScore":34,"stadium":"Paul Brown Stadium"},
      "bal_sd" :{"date":"Sun Nov 25","start":"13:05:00","away":"bal","home":"sd","awayScore":16,"homeScore":13,"stadium":"Qualcomm Stadium"},
      "sf_no"  :{"date":"Sun Nov 25","start":"13:25:00","away":"sf","home":"no","awayScore":31,"homeScore":21,"stadium":"Mercedes-Benz Superdome"},
      "stl_ari":{"date":"Sun Nov 25","start":"13:25:00","away":"stl","home":"ari","awayScore":31,"homeScore":17,"stadium":"University of Phoenix Stadium"},
      "gb_nyg" :{"date":"Sun Nov 25","start":"17:20:00","away":"gb","home":"nyg","awayScore":10,"homeScore":38,"stadium":"MetLife Stadium"}
      },

      "13":{
      "hou_ten":{"date":"Sun Dec 2","start":"10:00:00","away":"hou","home":"ten","awayScore":24,"homeScore":10,"stadium":"LP Field"},
      "ne_mia" :{"date":"Sun Dec 2","start":"10:00:00","away":"ne","home":"mia","awayScore":23,"homeScore":16,"stadium":"Sun Life Stadium"},
      "jac_buf":{"date":"Sun Dec 2","start":"10:00:00","away":"jac","home":"buf","awayScore":18,"homeScore":34,"stadium":"Ralph Wilson Stadium"},
      "ind_det":{"date":"Sun Dec 2","start":"10:00:00","away":"ind","home":"det","awayScore":35,"homeScore":33,"stadium":"Ford Field"},
      "car_kc" :{"date":"Sun Dec 2","start":"10:00:00","away":"car","home":"kc","awayScore":21,"homeScore":27,"stadium":"Arrowhead Stadium"},
      "ari_nyj":{"date":"Sun Dec 2","start":"10:00:00","away":"ari","home":"nyj","awayScore":6,"homeScore":7,"stadium":"MetLife Stadium"},
      "sf_stl" :{"date":"Sun Dec 2","start":"10:00:00","away":"sf","home":"stl","awayScore":13,"homeScore":16,"stadium":"Edward Jones Dome"},
      "min_gb" :{"date":"Sun Dec 2","start":"10:00:00","away":"min","home":"gb","awayScore":14,"homeScore":23,"stadium":"Lambeau Field"},
      "sea_chi":{"date":"Sun Dec 2","start":"10:00:00","away":"sea","home":"chi","awayScore":23,"homeScore":17,"stadium":"Soldier Field"},
      "tb_den" :{"date":"Sun Dec 2","start":"13:05:00","away":"tb","home":"den","awayScore":23,"homeScore":31,"stadium":"Sports Authority Field at Mile High"},
      "cin_sd" :{"date":"Sun Dec 2","start":"13:25:00","away":"cin","home":"sd","awayScore":20,"homeScore":13,"stadium":"Qualcomm Stadium"},
      "cle_oak":{"date":"Sun Dec 2","start":"13:25:00","away":"cle","home":"oak","awayScore":20,"homeScore":17,"stadium":"O.co Coliseum"},
      "pit_bal":{"date":"Sun Dec 2","start":"13:25:00","away":"pit","home":"bal","awayScore":23,"homeScore":20,"stadium":"M&T Bank Stadium"},
      "phi_dal":{"date":"Sun Dec 2","start":"17:20:00","away":"phi","home":"dal","awayScore":33,"homeScore":38,"stadium":"Cowboys Stadium"}
      }
      };

generateMatchups();
// Generate week/matchup dropdowns for nav bar
function generateMatchups() {
  $.each( matchups, function(w) {
    var weekNav = $('<li>').attr('class','dropdown'),
        weekLink = $('<a>')
                      .attr({
                          'id':'dweek'+w,
                          'href':'#',
                          'role':'button',
                          'class':'dropdown-toggle',
                          'data-toggle':'dropdown'
                          })
                      .html('Week '+w+' <b class="caret"></b>'),
        allLink = $('<li>').html('<a tabindex="-1" href="/week/'+w+'/">All Matchups</a>'),
        weekList = $('<ul>').attr({'class':'dropdown-menu', 'role':'menu', 'aria-labelledby':'dweek'+w});
    weekLink.appendTo(weekNav);
    weekList.appendTo(weekNav);
    weekNav.appendTo('.nav');

    allLink.appendTo(weekList);

    $.each( matchups[w], function(i) {
      var matchupInfo = matchups[w][i],
          awayTeam = matchupInfo.away,
          homeTeam = matchupInfo.home,
          matchupNav = $('<li>'),
          matchupLink = $('<a>').attr({'class':'matchup','tabindex':'-1','href':'/week/'+w+'/matchup/'+i+'/'})
                                .html('<img class="pull-left logoTiny" src="/pigskin/static/img/logo/'+awayTeam+'.gif">'+ awayTeam.toUpperCase() +' vs ' + homeTeam.toUpperCase() + '<img class="pull-right logoTiny" src="/pigskin/static/img/logo/'+homeTeam+'.gif">');
      matchupLink.appendTo(matchupNav);
      matchupNav.appendTo(weekList);
    });
  });
}

// Index page
if ( $('#index').length ) {
  var graph = new Rickshaw.Graph( {
    element: document.querySelector("#chart"),
    // width: 960,
    height: 500,
    renderer: 'bar',
    series: [
      {
        color: "#007883",
        data: data['football'],
        name: "Football Tweets"
      },
      {
        color: "#FF7883",
        data: data['nonfootball'],
        name: "Non-football Tweets"
      }
      ]
  });

  var legend = new Rickshaw.Graph.Legend( {
    graph: graph,
    element: document.getElementById('legend')
  } );

  var shelving = new Rickshaw.Graph.Behavior.Series.Toggle( {
    graph: graph,
    legend: legend
  });

  graph.render();

  var hoverDetail = new Rickshaw.Graph.HoverDetail( {
    graph: graph
  });

  var ticksTreatment = 'glow';

  var xAxis = new Rickshaw.Graph.Axis.Time( {
    graph: graph,
    ticksTreatment: ticksTreatment
  } );

  xAxis.render();

  var yAxis = new Rickshaw.Graph.Axis.Y( {
    graph: graph,
    tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
    ticksTreatment: ticksTreatment
  } );

  yAxis.render();
}

// Teams page
if ( $('#teams').length ) {
  $.each(teams, function(i){
    var info = teams[i],
        entry = $('<div>')
                  .attr('class','teamListing')
                  .html('<a href="/teams/'+i+'"><img class="logoSmall" src="/pigskin/static/img/logo/'+i+'.gif"><span>'+info.name+'</span></a>');
    if (info.conf == "NFC") {
      entry.appendTo('#nfc');
    } else {
      entry.appendTo('#afc');
    }
  });
}

// Team page
if ( $('#team').length ) {
  var team = $('#team').data('team'),
      info = teams[team];
  $(document).attr('title', info.name+' | Pigskin | Visualizing Football Tweets');
  $('#teamName').text(info.name);
  $(".twitter-follow-button").attr('href','https://twitter.com/'+info.username).text('Follow @'+info.username);
  $('#teamTweets').html(teamCounts + ' tweets <small> total about team</small>');
    // Instantiate our graph!
  var graph = new Rickshaw.Graph( {
    element: document.querySelector("#chart"),
    width: 800,
    height: 400,
    renderer: 'bar',
    series: [{
      color: info.color,
      data: teamCount,
      name: info.name
    }]
  });

  graph.render();

  var hoverDetail = new Rickshaw.Graph.HoverDetail( {
    graph: graph,
    formatter: function(series, x, y) {
      var date = '<span class="date">' + new Date((x * 1000) ).toUTCString() + '</span>';
      var swatch = '<span class="detail_swatch" style="background-color: ' + series.color + '"></span>';
      var content = swatch + series.name + ": " + parseInt(y) + '<br>' + date;
      return content;
    }
  } );

  var legend = new Rickshaw.Graph.Legend( {
    graph: graph,
    element: document.getElementById('legend')
  } );

  var shelving = new Rickshaw.Graph.Behavior.Series.Toggle( {
    graph: graph,
    legend: legend
  });

  var ticksTreatment = 'glow';

  var xAxis = new Rickshaw.Graph.Axis.Time( {
    graph: graph,
    ticksTreatment: ticksTreatment
  } );

  xAxis.render();

  var yAxis = new Rickshaw.Graph.Axis.Y( {
    graph: graph,
    tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
    ticksTreatment: ticksTreatment
  } );

  yAxis.render();
}

// Week page
if ( $('#week').length ) {
  // console.log(teamData);
  // console.log(trendingTopics);
  $.each(trendingTopics, function(i){
    $("<li>").text(trendingTopics[i]["term"]).appendTo("#trending");
  });

  var seriesData = [];
  $.each(teamData, function(i){
      var seriesEntry = {};
      seriesEntry.color = teams[i]["color"];
      seriesEntry.data = teamData[i][week];
      seriesEntry.name = teams[i]["name"];
      seriesData.push(seriesEntry);
  });

  // Instantiate our graph!
  var graph = new Rickshaw.Graph( {
    element: document.querySelector("#chart"),
    // width: 800,
    height: 400,
    renderer: 'line',
    series: seriesData
  });

  graph.render();

  var hoverDetail = new Rickshaw.Graph.HoverDetail( {
    graph: graph,
    formatter: function(series, x, y) {
      var date = '<span class="date">' + new Date((x * 1000) ).toUTCString() + '</span>';
      var swatch = '<span class="detail_swatch" style="background-color: ' + series.color + '"></span>';
      var content = swatch + series.name + ": " + parseInt(y) + '<br>' + date;
      return content;
    }
  } );

  var legend = new Rickshaw.Graph.Legend( {
    graph: graph,
    element: document.getElementById('legend')
  } );

  var shelving = new Rickshaw.Graph.Behavior.Series.Toggle( {
    graph: graph,
    legend: legend
  });

  var slider = new Rickshaw.Graph.RangeSlider( {
    graph: graph,
    element: $('#slider')
  } );

  var ticksTreatment = 'glow';

  var xAxis = new Rickshaw.Graph.Axis.Time( {
    graph: graph,
    ticksTreatment: ticksTreatment
  } );

  xAxis.render();

  var yAxis = new Rickshaw.Graph.Axis.Y( {
    graph: graph,
    tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
    ticksTreatment: ticksTreatment
  } );

  yAxis.render();

}

// Matchup page
if ( $('#matchup').length ) {
  var currentMatchup = matchup.split("_"), //split matchup into the different teams
      awayTeam = currentMatchup[0],
      homeTeam = currentMatchup[1],
      matchupInfo = matchups[week][matchup];

  $("#matchupLocation").html(matchupInfo["stadium"]);
  $("#matchupScore").html(matchupInfo["awayScore"] +' - '+ matchupInfo["homeScore"]);

  $('#away img').attr("src","/pigskin/static/img/logo/"+awayTeam+".gif");
  $('#home img').attr("src","/pigskin/static/img/logo/"+homeTeam+".gif");

  $('#away h3').text(teams[awayTeam]["name"]);
  $('#home h3').text(teams[homeTeam]["name"]);

  $("#away .twitter-follow-button").attr('href','https://twitter.com/'+teams[awayTeam]["username"]).text('Follow @'+teams[awayTeam]["username"]);
  $("#home .twitter-follow-button").attr('href','https://twitter.com/'+teams[homeTeam]["username"]).text('Follow @'+teams[homeTeam]["username"]);

  var awayTopTen = topTen[awayTeam][awayTeam];
  $.each(awayTopTen, function(i){
      $("<li>").html('<a href="https://twitter.com/'+awayTopTen[i]["username"]+'">@' + awayTopTen[i]["username"]+'</a> - '+ awayTopTen[i]["tweet"] ).appendTo('#awayTopTen');
  });

  var homeTopTen = topTen[homeTeam][homeTeam];
  $.each(awayTopTen, function(i){
      $("<li>").html('<a href="https://twitter.com/'+homeTopTen[i]["username"]+'">@' + homeTopTen[i]["username"]+'</a> - '+ homeTopTen[i]["tweet"] ).appendTo('#homeTopTen');
  });

  // Instantiate our graph!
  var graph = new Rickshaw.Graph( {
    element: document.querySelector("#chart"),
    // width: 800,
    height: 400,
    renderer: 'line',
    series: [
      {
        color: teams[awayTeam]["color"],
        data: teamData[awayTeam][week],
        name: teams[awayTeam]["name"]
      },
      {
        color: teams[homeTeam]["color"],
        data: teamData[homeTeam][week],
        name: teams[homeTeam]["name"]
      }
      ]
  });

  // graph.renderer.unstack = true;
  graph.render();

  // var hoverDetail = new Rickshaw.Graph.HoverDetail( {
  //   graph: graph
  // } );

  var hoverDetail = new Rickshaw.Graph.HoverDetail( {
    graph: graph,
    formatter: function(series, x, y) {
      var date = '<span class="date">' + new Date((x * 1000) ).toUTCString() + '</span>';
      var swatch = '<span class="detail_swatch" style="background-color: ' + series.color + '"></span>';
      var content = swatch + series.name + ": " + parseInt(y) + '<br>' + date;
      return content;
    }
  } );


  var legend = new Rickshaw.Graph.Legend( {
    graph: graph,
    element: document.getElementById('legend')
  } );

  var shelving = new Rickshaw.Graph.Behavior.Series.Toggle( {
    graph: graph,
    legend: legend
  });

  var slider = new Rickshaw.Graph.RangeSlider( {
    graph: graph,
    element: $('#slider')
  } );

    // var axes = new Rickshaw.Graph.Axis.Time( {
    //   graph: graph
    // } );
    // axes.render();

  var ticksTreatment = 'glow';

  var xAxis = new Rickshaw.Graph.Axis.Time( {
    graph: graph,
    ticksTreatment: ticksTreatment
  } );

  xAxis.render();

  var yAxis = new Rickshaw.Graph.Axis.Y( {
    graph: graph,
    tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
    ticksTreatment: ticksTreatment
  } );

  yAxis.render();


}


});
