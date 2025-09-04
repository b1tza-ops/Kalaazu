package net.bigpoint.darkorbit.questfm
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.net.ServerCommands;
   
   public class QuestDotList extends SimpleContainer
   {
      
      private var _dots:Array = [];
      
      private var _quests_in_order:Array = [];
      
      private var _main:Main;
      
      public function QuestDotList(param1:Main)
      {
         super(param1.getGuiManager(),SimpleContainer.CLASS_QUEST_PAGE_DOTS);
         this._main = param1;
      }
      
      public function update() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         var _loc3_:int = 0;
         if(this._main.getQuestManager().privilegedQuest != null)
         {
            _loc3_ = int(this._main.getQuestManager().privilegedQuest.id);
         }
         var _loc4_:int = 0;
         while(_loc4_ < this._quests_in_order.length)
         {
            if(this._quests_in_order[_loc4_] != null)
            {
               _loc2_ = int(this._quests_in_order[_loc4_]);
               if(_loc3_ == _loc2_)
               {
                  this._dots[_loc2_].gotoAndStop("active");
               }
               else
               {
                  this._dots[_loc2_].gotoAndStop("inactive");
               }
               this._dots[_loc2_].x = _loc1_;
               _loc1_ += this._dots[_loc2_].width + 4;
            }
            _loc4_++;
         }
      }
      
      private function addPrivilegeFunction(param1:MovieClip, param2:int) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.onClickPrivilege);
         param1.buttonMode = true;
      }
      
      private function onClickPrivilege(param1:MouseEvent) : void
      {
         var _loc2_:int = int(this._dots.indexOf(MovieClip(param1.target)));
         if(_loc2_ != this._main.getQuestManager().privilegedQuest.id)
         {
            this._main.getConnectionManager().sendCommand(ServerCommands.QUESTFM_INFO,[ServerCommands.QUESTFM_PRIVILEGE_QUEST,_loc2_]);
         }
      }
      
      public function addQuest(param1:int) : void
      {
         var _loc2_:MovieClip = null;
         if(this._dots[param1] == null)
         {
            _loc2_ = this.getQuestUiElement("pagedot");
            this._dots[param1] = _loc2_;
            this._quests_in_order.push(param1);
            this.addPrivilegeFunction(_loc2_,param1);
            addChild(_loc2_);
         }
         this.update();
      }
      
      public function removeQuest(param1:int) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         if(this._dots[param1] != null)
         {
            _loc2_ = MovieClip(this._dots[param1]);
            if(contains(_loc2_))
            {
               removeChild(_loc2_);
            }
            delete this._dots[param1];
            _loc3_ = 0;
            while(_loc3_ < this._quests_in_order.length)
            {
               if(this._quests_in_order[_loc3_] == param1)
               {
                  delete this._quests_in_order[_loc3_];
               }
               _loc3_++;
            }
         }
         this.update();
      }
      
      private function getQuestUiElement(param1:String) : MovieClip
      {
         var _loc2_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("questSystem"));
         return _loc2_.getEmbededMovieClip(param1);
      }
   }
}

