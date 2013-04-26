package com.nicotroia.typinggame.model
{
	import com.feathers.system.DeviceCapabilities;
	import com.nicotroia.typinggame.controller.events.LayoutEvent;
	
	import flash.display.Screen;
	import flash.display.StageOrientation;
	import flash.system.Capabilities;
	
	import org.robotlegs.mvcs.Actor;
	
	import starling.core.Starling;

	public class LayoutModel extends Actor
	{
		private static const ORIGINAL_DPI_IPHONE_RETINA:int = 326;
		private static const ORIGINAL_DPI_IPAD_RETINA:int = 264;
		
		public var scale:Number = 1;
		public var appWidth:Number;
		public var appHeight:Number;
		
		public var arialBold:ArialBold;
		public var arialRegular:ArialRegular;
		
		private var _orientation:String;
		private var _originalDPI:int;
		private var _scaleToDPI:Boolean;
		
		public function LayoutModel()
		{
			_scaleToDPI = true;
			const scaledDPI:int = DeviceCapabilities.dpi / Starling.contentScaleFactor;
			this._originalDPI = scaledDPI;
			if(this._scaleToDPI)
			{
				if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
				{
					this._originalDPI = ORIGINAL_DPI_IPAD_RETINA;
				}
				else
				{
					this._originalDPI = ORIGINAL_DPI_IPHONE_RETINA;
				}
			}
			
			//app dpi scale
			this.scale = scaledDPI / this._originalDPI;
			
			_orientation = StageOrientation.UNKNOWN;
			
			//These initial values will be changed in LayoutPageCommand
			if( Capabilities.version.substr(0,3).toUpperCase() == "AND" ) { //android device
				appWidth = Starling.current.nativeStage.stageWidth;
				appHeight = Starling.current.nativeStage.stageHeight;
			}
			else { 
				appWidth = Starling.current.nativeStage.fullScreenWidth;
				appHeight = Starling.current.nativeStage.fullScreenHeight;
			}
			
			//misc
			arialBold = new ArialBold();
			arialRegular = new ArialRegular();
			
			trace("LayoutModel init");
		}
		
		public function changeAppLayout($orientation:String, $appWidth:Number, $appHeight:Number):void
		{
			_orientation = $orientation;
			appWidth = $appWidth;
			appHeight = $appHeight;
			
			setNewProperties();
			
			eventDispatcher.dispatchEvent(new LayoutEvent(LayoutEvent.UPDATE_LAYOUT));
		}
		
		public function get orientation():String { return _orientation; }
		
		public function set orientation( _o:String ):void 
		{ 		
			//Using a new Event stops multiple Event.RESIZE calls from forcing pages to resize for no reason
			//However, on iOS the proper stageWidth/Height are not reported until the SECOND event...
			
			if( _orientation !== _o ) 
			{ 	
				//trace("Orientation change: " + _orientation + " to " + _o);
				
				setNewProperties();
				
				_orientation = _o; 
				
				eventDispatcher.dispatchEvent(new LayoutEvent(LayoutEvent.UPDATE_LAYOUT));
			}
			
		}
		
		private function setNewProperties():void
		{
			switch( _orientation ) { 
				case StageOrientation.DEFAULT : 
					//navBarHeight = 150 * this.scale * Starling.contentScaleFactor;
					break;
				case StageOrientation.ROTATED_LEFT : 
					//navBarHeight = 120 * this.scale * Starling.contentScaleFactor;
					break;
				case StageOrientation.ROTATED_RIGHT : 
					//navBarHeight = 120 * this.scale * Starling.contentScaleFactor;
					break;
				case StageOrientation.UPSIDE_DOWN : 
					//navBarHeight = 150 * this.scale * Starling.contentScaleFactor;
					break;
				case StageOrientation.UNKNOWN : 
					//navBarHeight = 0;
					break;
				default : 
					break;
			}
		}
	}
}