package com.nicotroia.typinggame.controller.commands
{	
	import com.nicotroia.typinggame.controller.events.NavigationEvent;
	import com.nicotroia.typinggame.model.SequenceModel;
	import com.nicotroia.typinggame.view.pages.PageBase;
	
	import flash.events.Event;
	import flash.system.System;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	
	import org.robotlegs.mvcs.StarlingCommand;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;

	public class GotoPageCommand extends StarlingCommand
	{
		[Inject]
		public var event:NavigationEvent;
		
		[Inject]
		public var sequenceModel:SequenceModel;
		
		[Inject(name="pageContainer")]
		public var pageContainer:Sprite;
		
		[Inject(name="overlayContainer")]
		public var overlayContainer:Sprite;
		
		private var _pageConstant:Class;
		private var _lastPage:PageBase;
		private var _newPage:PageBase;
		private var _assetRemoval:Vector.<PageBase>;
		
		override public function execute():void
		{
			if( event.type != NavigationEvent.NAVIGATE_TO_PAGE 
				|| sequenceModel.isTransitioning 
			) return;
			else trace("GotoPageCommand " + NavigationEvent(event).pageConstant) + " via " + event.type;
			
			sequenceModel.isTransitioning = true;
			
			_pageConstant = NavigationEvent(event).pageConstant;
			_lastPage = sequenceModel.currentPage;
			_newPage = sequenceModel.getPage( _pageConstant );
			
			var pageSpeed:Number = 0.42;
			var direction:String = event.direction;
			
			if( _newPage == _lastPage ) { 
				//just show the page and stop
				sequenceModel.isTransitioning = true;
				
				_newPage.show(pageSpeed, delay, direction, function():void { 
					sequenceModel.isTransitioning = false;
					
					end();
				});
				
				return;
			}
			
			_assetRemoval = new Vector.<PageBase>();
			
			//Remove all navigational buttons from header
			//eventDispatcher.dispatchEvent(new NavigationEvent(NavigationEvent.REMOVE_HEADER_NAV_BUTTONS));
			
			//Remove old page
			if( _lastPage != null && pageContainer.contains(_lastPage) ) { 
				_lastPage.hide(pageSpeed, 0, direction, function():void { 
					trace(" ---- removing " + _lastPage);
					pageContainer.removeChild(_lastPage);
					
					if( System.pauseForGCIfCollectionImminent != null ) { 
						//advise the player to trigger a sweep of marked memory if almost ready (0.75 default)
						System.pauseForGCIfCollectionImminent(); 
					}
				});
			}
			
			var delay:Number = 0; //0.15; 
			
			//Add any overlays that should belong on this page
			for each( var OverlayPage:Class in sequenceModel.overlayList ) { 
				//trace("checking if " + _pageConstant + " should include " + OverlayPage);
				
				var requiredOverlay:PageBase = sequenceModel.overlays[OverlayPage] as PageBase;
				if(requiredOverlay == null) continue;
				
				//if this overlay exists inside the overlay waiting list for this page
				if( Vector.<Class>(sequenceModel.overlayWaitingList[OverlayPage]).indexOf(_pageConstant) > -1 ) 
				{ 
					//add overlay that does belong
					if( ! overlayContainer.contains(requiredOverlay) ) { 
						//trace("adding overlay: " + requiredOverlay);
						overlayContainer.addChild(requiredOverlay);
						requiredOverlay.show(0.25, delay, direction);
						//delay += 0.15;
					}
				}
				else 
				{ 
					//remove overlay that does not belong
					if( requiredOverlay.parent == overlayContainer ) { 
						_assetRemoval.push( requiredOverlay );
						requiredOverlay.hide(0.25, delay, direction, function():void { 
							safeRemove(_assetRemoval.shift());
						});
						//delay += 0.1;
					}
				}
			}
			
			//Add the new page
			pageContainer.addChild(_newPage);
			
			_newPage.show(pageSpeed, delay, direction, function():void { 
				//finally... finish.
				sequenceModel.isTransitioning = false;
				
				end();
			});
		}
		
		protected function end():void
		{
			if( sequenceModel.cancelLoadingOncePageFullyLoads ) { 
				sequenceModel.cancelLoadingOncePageFullyLoads = false;
				
				setTimeout( function():void { 
					//trace("ok. page loaded. cancelling loading spinner.");
					eventDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.LOADING_FINISHED));
				}, 1);
			}
		}
		
		protected function safeRemove(obj:DisplayObject):void
		{
			if(obj.parent) obj.parent.removeChild(obj);
		}
	}
}