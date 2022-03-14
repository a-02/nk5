function random(number) {
  return Math.floor(Math.random() * (number));
}

const listoStrings =
	[ "Reverse."
	, "Cascades."
	, "Courage."
	, "Is there something missing?"
	, "Consult other sources."
	, "Call my name to tame the darkness."
	, "Words are trivial."
	, "I wish to God I'd never seen your face."
	, "I'm sorry you ever was born."
	, "It's alright now."
	, "Take it easy."
	, "Don't you worry."
	, "Mercy."
	, "Come down now, they'll say."
	, "Be not fearful. Come. Come away."
	, "Said so easily."
	, "Take me home."
	, "Stop complaining."
	, "It's hard to explain."
	, "God bless the grass."
	, "Fight towards the sun."
	, "Reach for the air."
	, "One grain of sand."
	, "A life is just a day."
	, "We are soldiers in the army."
	, "We shall overcome."
	, "Trust me."
	, "Everything changes. Nothing perishes."
	, "To the blind, all things are sudden."
	, "Something is wrong."
	, "Don't speak too soon."
	, "Inedible candy."
	, "Look over your shoulder."
        , "I'm gonna tell God how you treat me."
        , "Only passing through."
        , "All men are brothers."
        , "Let every voice be thunder."
	]

document.addEventListener('DOMContentLoaded', () => {
  const h3 = document.querySelector('h3');
  const topleft = document.getElementById('topleft');
  const fortune = document.getElementById('fortune');
  const body = document.querySelector('body');
  const rightNow = new Date();
  const hour = rightNow.getHours();

  if ((hour >= 9) && (hour <= 21)) {
    body.className = 'day';
    topleft.className = 'topleft day';
    fortune.className = 'fortune day';
  } else {
    body.className = 'night';
    topleft.className = 'topleft night';
    fortune.className = 'fortune night';
  }


  h3.addEventListener('click', () => {
    h3.textContent = listoStrings[random(listoStrings.length)]
  });

  topleft.addEventListener('click', () => {
    if (body.className === 'day') {
      body.className = 'night';
      topleft.className ='topleft night';
      fortune.className ='fortune night';
    } else {
      body.className = 'day';
      topleft.className = 'topleft day';
      fortune.className = 'fortune day';
    }
  });
});
