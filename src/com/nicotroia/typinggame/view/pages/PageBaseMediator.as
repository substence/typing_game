package com.nicotroia.typinggame.view.pages
{
	import com.nicotroia.typinggame.controller.events.LayoutEvent;
	import com.nicotroia.typinggame.model.LayoutModel;
	import com.nicotroia.typinggame.model.SequenceModel;
	
	import org.robotlegs.mvcs.StarlingMediator;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;

	public class PageBaseMediator extends StarlingMediator
	{
		[Inject]
		public var view:PageBase;
		
		[Inject(name="overlayContainer")]
		public var overlayContainer:Sprite;
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		[Inject]
		public var sequenceModel:SequenceModel;
		
		override public function onRegister():void
		{
			trace("pagebase mediator onRegister " + view);
			
			if( ! view.isBeingMediated ) { 
				view.addEventListener(Event.ADDED_TO_STAGE, pageAddedToStageHandler);
			}
			
			view.isBeingMediated = true; 
		}
		
		protected function pageAddedToStageHandler(event:Event = null):void
		{
			//This shit's expensive... Resize only the first time it's added
			if( ! view.reflowed ) { 
				callAppResizedHandler();
			}
			
			view.addEventListener(Event.RESIZE, callAppResizedHandler);
			eventMap.mapListener(eventDispatcher, LayoutEvent.UPDATE_LAYOUT, reflowPage);
		}
		
		protected function callAppResizedHandler():void
		{
			reflowPage();
		}
		
		protected function reflowPage(event:LayoutEvent = null):void
		{
			if( ! view.parent ) return;
			
			view.reflowed = false;
			
			view.reflowVectors(layoutModel);
			view.drawVectors(layoutModel);
			
			view.reflowed = true;
		}
		
		protected function addToOverlay(obj:DisplayObject):void
		{
			overlayContainer.addChild(obj);
		}
		
		protected function removeFromOverlay(obj:DisplayObject):void
		{
			overlayContainer.removeChild(obj);
		}
		
		override public function onRemove():void
		{
			view.removeEventListener(Event.RESIZE, callAppResizedHandler);
			eventMap.unmapListener(eventDispatcher, LayoutEvent.UPDATE_LAYOUT, reflowPage);
			
			//trace("pagebase onRemove");
			
			super.onRemove();
		}
	}
}