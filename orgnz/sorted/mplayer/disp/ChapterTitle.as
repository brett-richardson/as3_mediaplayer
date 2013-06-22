package orgnz.sorted.mplayer.disp {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import orgnz.sorted.mplayer.WindowManager;
	
	// Library assets
	import lib.chap_title_popup_centre;
	import lib.chap_title_popup_left;
	import lib.chap_title_popup_right;
	
	/**
	 * @author Brett Richardson
	 */
	
	 
	public class ChapterTitle extends Sprite {
		
		public var
		nTargetY	:Number;
		
		
		private static var
		tFormat		:TextFormat;
		
		private var
		tfTitle		:TextField,
		spCentre	:Sprite,
		bmLeft		:Bitmap,
		bmRight		:Bitmap;
		
		
		
		public function ChapterTitle( sTitle:String, nX:Number, nY:Number ) {
			if ( !tFormat ) createTextFormat();
			
			buildBg();
			buildTitle( sTitle );
			sizeBg();
			reposition( nX, nY );
		}
		
		
		public function reposition( nX:Number, nY:Number ) {
			x = Math.floor( nX ) - 20;
			nTargetY = y = Math.floor( nY - height ) - 10;
			
			if ( x + width > WindowManager.dStage.stageWidth ) {
				trace( 'OVerlap screen edge' );
				scaleX *= -1;
				x += 43;
				tfTitle.scaleX *= -1;
				tfTitle.x += Math.abs( width / 2 ) - 5;
			}
		}
		
		
		private function createTextFormat() {
			tFormat = new TextFormat();
			tFormat.color = 0xFFFFFF;
			tFormat.font = 'Arial,sans';
			tFormat.size = 14;
		}
		
		
		private function buildTitle( sTitle:String ) {
			if ( tfTitle ) removeChild( tfTitle );
			
			tfTitle = new TextField();
			tfTitle.htmlText = '<span class="title">' + sTitle + '</span>';
			tfTitle.setTextFormat( tFormat );
			tfTitle.x = 10;
			tfTitle.y = 7;
			tfTitle.cacheAsBitmap = true;
			
			addChild( tfTitle );
		}
		
		
		private function buildBg() {
			if ( bmLeft ) removeChild( bmLeft );
			if ( spCentre ) removeChild( spCentre );
			if ( bmRight ) removeChild( bmRight );
			
			bmLeft = new Bitmap( new chap_title_popup_left( 0, 0 ) );
			bmRight = new Bitmap( new chap_title_popup_right( 0, 0 ) );
			
			spCentre = new Sprite();
			spCentre.graphics.beginBitmapFill( new chap_title_popup_centre( 0, 0 ) );
			spCentre.graphics.drawRect( 0, 0, 10, 43 );
			spCentre.graphics.endFill();
			
			addChild( spCentre );
			addChild( bmLeft );
			addChild( bmRight );
		}
		
		
		private function sizeBg(){
			tfTitle.autoSize = 'left';
			tfTitle.antiAliasType = AntiAliasType.ADVANCED;
			tfTitle.cacheAsBitmap = false;
			
			spCentre.x = bmLeft.width;
			spCentre.width = Math.ceil( tfTitle.width - ( bmLeft.width + bmRight.width ) + 20 );
			
			bmRight.x = spCentre.x + spCentre.width;
		}
	}
}