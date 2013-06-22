package {
	import flash.display.Sprite;
	
	import orgnz.sorted.mplayer.Playlist;
	import orgnz.sorted.mplayer.WindowManager;
	import orgnz.sorted.mplayer.disp.VideoFrame;
	
	import Config;
	
	/**
	 * Main class for Sorted Media Player
	 * @version 2.0.alpha
	 * @author Brett Richardson
	 */
	
	public class Main extends Sprite {
		
		public static var
		bMode		:Boolean, //true -> playlist mode
		plList		:Playlist;
		
		
		public function Main (){
			Config.loadVars( this );
			WindowManager.init( this );
			
			spVideoFrame = new VideoFrame();
			
			if ( Config.xmlURL && Config.xmlURL.length > 0 ) {
				playlistMode();
			} else if ( Config.singleURL && Config.singleURL.length > 0 ) {
				singleMode();
			} else {
				throw new Error( 'Nothing to load.' );
			}
		}
		
		
		public function playlistMode():void {
			bMode = true;
			plList = new Playlist().load( Config.xmlURL );
		}
		
		
		public function singleMode():void {
			bMode = false;
			//TODO: Process single file
		}
		
	}
	
}