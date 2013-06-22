package orgnz.sorted.mplayer.disp {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.FontStyle;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import orgnz.sorted.mplayer.WindowManager;
	
	/**
	 * ...
	 * @author Brett Richardson
	 */
	
	
	public class Timer extends Sprite {
		
		private var
		tfTimer			:TextField,
		nTotalSecs		:Number,
		nCurrentSecs	:Number,
		stStyle			:StyleSheet;
		
		
		
		public function Timer() {
			tfTimer = new TextField();
			tfTimer.x = -4;
			addChild( tfTimer );
			
			stStyle = new StyleSheet();
			stStyle.parseCSS('.sans{font-family:Arial,sans;font-size:11px;}');
			tfTimer.styleSheet = stStyle;
			
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
		}
		
		
		private function onAddedToStage( event:Event ) {
			addEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
		
		
		private function onEnterFrame( event:Event ) {
			try{
				var mcCurrent:MovieClip = WindowManager.spVideoFrame.chCurrent.mcContainer;
				nCurrentSecs = mcCurrent.currentFrame / stage.frameRate;
				nTotalSecs = mcCurrent.totalFrames / stage.frameRate;
				
				var sTime:String = '';
				sTime += Math.floor( nCurrentSecs / 60 ) + ':';
				sTime += ( nCurrentSecs % 60 < 10 )? 
					'0' + Math.floor( nCurrentSecs % 60 ) 
					: Math.floor( nCurrentSecs % 60 );
				sTime += ' / ';
				sTime += Math.floor( nTotalSecs / 60 ) + ':';
				sTime += ( nTotalSecs % 60 < 10 )? 
					'0' + Math.floor( nTotalSecs % 60 ) 
					: Math.floor( nTotalSecs % 60 );
				
				tfTimer.htmlText = '<span class="sans">' + sTime + '</span>';
			} catch ( e:Error ) {}
		}
		
	}
	
}