$(function(){
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
    matchups = {};

    //Teams page
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

    //Single team page
    if ( $('#team').length ) {
      var team = $('#team').data('team'),
          info = teams[team];
      console.log(info);
      $('#teamName').text(info.name);
    }

    // $('ul.nav > li > a[href="' + document.location.pathname + '"]').parent().addClass('active');

});
