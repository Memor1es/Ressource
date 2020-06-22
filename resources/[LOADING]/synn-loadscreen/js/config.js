var config =
{    
    /*
        Do we want to show the image?
        Note that imageSize still affects the size of the image and where the progressbars are located.
    */
    enableImage: true,
 
    /*
        Relative path the the logo we want to display.
    */
    image: "img/logo.png",

    /*
        Cursor image
    */
    cursorImage: "img/cursor.png",
 
    /*
        How big should the logo be?
        The values are: [width, height].
        Recommended to use square images less than 1024px.
    */
    imageSize: [512, 512],
 
    /*
        Define the progressbar type
            0 = Single progressbar
            1 = Multiple progressbars
            2 = Collapsed progressbars
     */
    progressBarType: 2,
 
    /*
        Here you can disable some of progressbars.
        Only applys if `singleProgressbar` is false.
    */
    progressBars:
    {
        "INIT_CORE": {
            enabled: false, //NOTE: Disabled because INIT_CORE seems to not get called properly. (race condition).
        },
 
        "INIT_BEFORE_MAP_LOADED": {
            enabled: true,
        },
 
        "MAP": {
            enabled: true,
        },
 
        "INIT_AFTER_MAP_LOADED": {
            enabled: true,
        },
 
        "INIT_SESSION": {
            enabled: true,
        }
    },
 
    /*
        Loading messages will be randomly picked from the array.
        The message is located on the left side above the progressbar.
        The text will slowly fade in and out, each time with another message.
        You can use UTF-8 emoticons inside loading messages!
    */
    loadingMessages:
    [
        "Bienvenue sur Holliday's",
        "Appuyez sur F2 pour prendre votre te&#769le&#769phone",
        "Appuyez sur F5 pour regarder votre inventaire",
        "Pensez a&#768 lire le Re&#769glement et le Code Pe&#769nal",
        "Vous etes beaux",
        "Carter est un ripoux",
        "Pour tuer quelqu'un vous devez faire un dossier de Mort RP",
        "ptdr t ki ?",
        "Momo arriveras jamais a&#768 toucher Caitlyn lol",
	"Le Streamhack est interdit",
	"ET CA FAIT BIM BAM BOOM"
    ],
 
    /*
        Rotate the loading message every 5000 milliseconds (default value).
    */
    loadingMessageSpeed: 5 * 600,
 
    /*
        Array of music id's to play in the loadscreen.
        Enter your youtube video id's here. In order to obtain the video ID
        Take whats after the watch?v= on a youtube link.
        https://www.youtube.com/watch?v=<videoid>
        Do not include the playlist id or anything, it should be a 11 digit code.
       
        Do not use videos that:
            - Do not allow embedding.
            - Copyrighted music (youtube actively blocks this).
    */
    music:
    [
        "rAL4r4nC8Nw",
	"XOcp3fsK1g4",
	"T7VJECLb2s4",
    ],
 
 
    /*
        Set to false if you do not want any music.
    */
    enableMusic: true,
 
    /*
        Default volume for the player. Please keep this under 50%, to not blowout someones eardrums x)
     */
    musicVolume: 20,
 
    /*
        Should the background change images?
        True: it will not change backgrounds.
        False: it will change backgrounds.
    */
    staticBackground: false,
   
    /*
        Array of images you'd like to display as the background.
        Provide a path to a local image, using images via url is not recommended.
    */
    background:
    [
	"img/bg.jpg",
	"img/bg1.jpg",
	"img/bg2.jpg",
	"img/bg3.jpg",
	"img/bg4.jpg",
	"img/bg5.jpg",
	"img/bg6.jpg",
	"img/bg7.jpg",
	"img/bg8.jpg",
	"img/bg9.jpg",
	"img/bg10.jpg",
	"img/bg11.jpg",
	"img/bg12.jpg",
	"img/bg13.jpg",
	"img/bg14.jpg",
	"img/bg15.jpg",
	"img/bg16.jpg",
    ],
 
    /*
        Time in milliseconds on how fast the background
        should swap images.
     */
    backgroundSpeed: 2500,

    /*
        Which style of animation should the background transition be?
        zoom = background zooms in and out.
        slide = transtion backgrounds from sliding right and back again.
        fade = fade the background out and back in.
    */
    backgroundStyle: "fade",

    /*
        Should the log be visible? Handy for debugging!
    */
    enableLog: true,
}
