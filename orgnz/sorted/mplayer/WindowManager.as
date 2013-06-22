package orgnz.sorted.mplayer {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.display.LineScaleMode;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.geom.Matrix;
	
	import orgnz.sorted.mplayer.disp.ControlBar;
	import orgnz.sorted.mplayer.disp.VideoFrame;
	
	/**
	 * ...
	 * @author Brett Richardson
	 */
	
	public class WindowManager {
		
		public static var
		spVideoFrame	:VideoFrame,
		dRoot			:DisplayObject,
		dStage			:Stage,
		bFullscreen		:Boolean = false,
		spBorder		:Sprite, 
		spControlBar	:ControlBar;
		
		
		public static function init( dObj:DisplayObject ) {
			dRoot = dObj;
			dStage = dObj.stage;
			
			dStage.addEventListener( Event.RESIZE, onStageResize );
			dRoot.addEventListener( Event.ACTIVATE, onStageResize );
			
			dStage.scaleMode = StageScaleMode.NO_SCALE;
			dStage.align = StageAlign.TOP_LEFT;
			
			spVideoFrame = new VideoFrame();
			dStage.addChild( spVideoFrame );
			
			spControlBar = new ControlBar();
			dStage.addChild( spControlBar );
			
			dStage.dispatchEvent( new Event( Event.RESIZE, true ) );
		}
		
		
		public static function drawBorder() {
			if ( bFullscreen ) return false;
			
			if ( !spBorder ) { 
				spBorder = new Sprite();
				dStage.addChild( spBorder );
			}
			
			spBorder.graphics.clear();
			spBorder.graphics.lineStyle( 1, 0xD7D7D7, 1, true, LineScaleMode.NONE );
			spBorder.graphics.drawRect( 0, 0, dStage.stageWidth-1, dStage.stageHeight-1 );
		}

		
		public static function onStageResize( event:Event ) {
			drawBorder();
		}
		
		
		public static function getFullBounds( displayObject:DisplayObject ) :Rectangle {
			var bounds:Rectangle, transform:Transform,
				toGlobalMatrix:Matrix, currentMatrix:Matrix;
			
			transform = displayObject.transform;
			currentMatrix = transform.matrix;
			toGlobalMatrix = transform.concatenatedMatrix;
			toGlobalMatrix.invert();
			transform.matrix = toGlobalMatrix;
			
			bounds = transform.pixelBounds.clone();
			
			transform.matrix = currentMatrix;
			
			return bounds;
		}
	}
}