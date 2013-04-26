package com.nicotroia.typinggame.view.overlays
{
	import com.nicotroia.typinggame.controller.events.LayoutEvent;
	import com.nicotroia.typinggame.model.LayoutModel;
	
	import flash.events.MouseEvent;
	
	import org.robotlegs.mvcs.StarlingMediator;

	public class ShadowBoxMediator extends StarlingMediator
	{
		[Inject]
		public var view:ShadowBoxView;
		
		[Inject]
		public var layoutModel:LayoutModel;
		
		override public function onRegister():void
		{
			super.onRegister();
			
			//eventMap.mapListener(view, MouseEvent.CLICK, shadowBoxClickHandler);
			
			eventDispatcher.addEventListener(LayoutEvent.UPDATE_LAYOUT, appResizedHandler);
		}
		
		private function appResizedHandler(event:LayoutEvent):void
		{
			view.x = view.y = 0;
			view.draw(layoutModel.appWidth, layoutModel.appHeight, 0x333333);
		}
		
		private function shadowBoxClickHandler(event:MouseEvent):void
		{
			//eventDispatcher.dispatchEvent(new InteractionEvent(InteractionEvent.SHADOW_BOX_CLICKED));
		}
		
		override public function onRemove():void
		{
			eventDispatcher.removeEventListener(LayoutEvent.UPDATE_LAYOUT, appResizedHandler);
			
			super.onRemove();
		}
	}
}