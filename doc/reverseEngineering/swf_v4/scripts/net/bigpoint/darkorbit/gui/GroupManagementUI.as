package net.bigpoint.darkorbit.gui
{
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.MovieClip;
   import net.bigpoint.darkorbit.groupsystem.Group;
   
   public class GroupManagementUI extends MovieClip
   {
      
      private var _group:Group;
      
      private var _uiButtons:Array = [];
      
      private var _buttonConfig:Array = [];
      
      private var _groupUi:GroupUI;
      
      private var _heroIsBoss:Boolean;
      
      private var _editMode:Boolean;
      
      private var _editType:uint;
      
      private var _invitionsBehaviour:int;
      
      public function GroupManagementUI(param1:GroupUI)
      {
         super();
         this._groupUi = param1;
         this.initConfig();
      }
      
      private function initConfig() : void
      {
         this._buttonConfig[GroupActionButton.TYPE_PING] = new MgmtBtnConfig(this._groupUi.handlePingBtnToggle,"label_grp_context_item_ping");
         this._buttonConfig[GroupActionButton.TYPE_KICK] = new MgmtBtnConfig(this._groupUi.handleKickBtnToggle,"label_grp_kick_member");
         this._buttonConfig[GroupActionButton.TYPE_LEAVE] = new MgmtBtnConfig(this._groupUi.handleLeaveBtnClick,"label_grp_leave_group_leaver");
         this._buttonConfig[GroupActionButton.TYPE_CHANGE_INVITATION_BEHAVIOR] = new MgmtBtnConfig(this._groupUi.handleChangeInvitationBehaviorBtnClick,"label_grp_change_invitation_behavior");
         this._buttonConfig[GroupActionButton.TYPE_CHANGE_INVITATION_BEHAVIOR_TO_FREE_FOR_ALL] = new MgmtBtnConfig(this._groupUi.handleChangeInvitationBehaviorBtnClick,"label_grp_change_invitation_behavior");
         this._buttonConfig[GroupActionButton.TYPE_CHANGE_INVITATION_BEHAVIOR_TO_BOSS_ONLY] = new MgmtBtnConfig(this._groupUi.handleChangeInvitationBehaviorBtnClick,"label_grp_change_invitation_behavior");
         this._buttonConfig[GroupActionButton.TYPE_PROMOTE] = new MgmtBtnConfig(this._groupUi.handlePromoteBtnToggle,"label_grp_leader_change");
         this._buttonConfig[GroupActionButton.TYPE_FOLLOW] = new MgmtBtnConfig(this._groupUi.handleFollowBtnToggle,"label_grp_context_item_follow");
      }
      
      public function editMode(param1:Boolean, param2:uint) : void
      {
         if(this._editType == param2)
         {
            this.getBarButton(this._editType).toggle(param1);
            this._editMode = param1;
         }
         else
         {
            if(this._editType != 0)
            {
               this.getBarButton(this._editType).toggle(false);
            }
            this._editMode = true;
            this._editType = param2;
            this.getBarButton(this._editType).toggle(true);
         }
         this._groupUi.updateEditMode(this._editMode,this._editType);
      }
      
      public function update(param1:Boolean = false) : void
      {
         var _loc5_:GroupActionButton = null;
         var _loc2_:Array = [];
         if(this._group != null && this._group.heroIsBoss)
         {
            _loc2_ = this.getAllBarButtons();
            this._heroIsBoss = true;
         }
         else
         {
            if(this._heroIsBoss = true)
            {
               this.hideAllBarButtons();
            }
            this._heroIsBoss = false;
            _loc2_ = this.getStandardBarButtons();
         }
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            if(!(_loc2_[_loc4_] == undefined || _loc2_[_loc4_] == null))
            {
               _loc5_ = GroupActionButton(_loc2_[_loc4_]);
               if(!contains(_loc5_))
               {
                  addChild(_loc5_);
               }
               if(param1)
               {
                  _loc5_.handleClick = MgmtBtnConfig(this._buttonConfig[_loc5_.type]).action;
               }
               else
               {
                  _loc5_.handleClick = null;
               }
               _loc5_.x = _loc3_;
               _loc3_ += _loc5_.width + 5;
            }
            _loc4_++;
         }
      }
      
      private function hideAllBarButtons() : void
      {
         var _loc1_:GroupActionButton = null;
         for each(_loc1_ in this._uiButtons)
         {
            if(contains(_loc1_))
            {
               removeChild(_loc1_);
            }
         }
      }
      
      private function getStandardBarButtons() : Array
      {
         var _loc1_:Array = [];
         _loc1_[GroupActionButton.TYPE_PING] = this.getBarButton(GroupActionButton.TYPE_PING);
         _loc1_[GroupActionButton.TYPE_LEAVE] = this.getBarButton(GroupActionButton.TYPE_LEAVE);
         _loc1_[GroupActionButton.TYPE_FOLLOW] = this.getBarButton(GroupActionButton.TYPE_FOLLOW);
         return _loc1_;
      }
      
      private function getAllBarButtons() : Array
      {
         var _loc1_:Array = [];
         _loc1_[GroupActionButton.TYPE_FOLLOW] = this.getBarButton(GroupActionButton.TYPE_FOLLOW);
         _loc1_[GroupActionButton.TYPE_PING] = this.getBarButton(GroupActionButton.TYPE_PING);
         _loc1_[GroupActionButton.TYPE_KICK] = this.getBarButton(GroupActionButton.TYPE_KICK);
         _loc1_[GroupActionButton.TYPE_LEAVE] = this.getBarButton(GroupActionButton.TYPE_LEAVE);
         _loc1_[GroupActionButton.TYPE_PROMOTE] = this.getBarButton(GroupActionButton.TYPE_PROMOTE);
         _loc1_[GroupActionButton.TYPE_CHANGE_INVITATION_BEHAVIOR] = this.getChangeInvitationBehaviourButton();
         return _loc1_;
      }
      
      private function getChangeInvitationBehaviourButton() : GroupActionButton
      {
         var _loc1_:GroupActionButton = null;
         var _loc2_:String = null;
         if(this._group != null && this._group.invitationBehavior == Group.INVITATION_BEHAVIOR_FREE_FOR_ALL)
         {
            if(this._invitionsBehaviour != Group.INVITATION_BEHAVIOR_FREE_FOR_ALL && this._uiButtons[GroupActionButton.TYPE_CHANGE_INVITATION_BEHAVIOR_TO_BOSS_ONLY] != null)
            {
               TooltipControl.getInstance().removeToolTip(this._uiButtons[GroupActionButton.TYPE_CHANGE_INVITATION_BEHAVIOR_TO_BOSS_ONLY]);
               GroupActionButton(this._uiButtons[GroupActionButton.TYPE_CHANGE_INVITATION_BEHAVIOR_TO_BOSS_ONLY]).handleClick = null;
               if(contains(this._uiButtons[GroupActionButton.TYPE_CHANGE_INVITATION_BEHAVIOR_TO_BOSS_ONLY]))
               {
                  removeChild(this._uiButtons[GroupActionButton.TYPE_CHANGE_INVITATION_BEHAVIOR_TO_BOSS_ONLY]);
               }
            }
            this._invitionsBehaviour = Group.INVITATION_BEHAVIOR_FREE_FOR_ALL;
            _loc1_ = this.getBarButton(GroupActionButton.TYPE_CHANGE_INVITATION_BEHAVIOR_TO_FREE_FOR_ALL);
            _loc2_ = "label_grp_invitation_behavior_free_for_all";
         }
         else
         {
            if(this._invitionsBehaviour != Group.INVITATION_BEHAVIOR_BOSS_ONLY && this._uiButtons[GroupActionButton.TYPE_CHANGE_INVITATION_BEHAVIOR_TO_FREE_FOR_ALL] != null)
            {
               TooltipControl.getInstance().removeToolTip(this._uiButtons[GroupActionButton.TYPE_CHANGE_INVITATION_BEHAVIOR_TO_FREE_FOR_ALL]);
               GroupActionButton(this._uiButtons[GroupActionButton.TYPE_CHANGE_INVITATION_BEHAVIOR_TO_FREE_FOR_ALL]).handleClick = null;
               if(contains(this._uiButtons[GroupActionButton.TYPE_CHANGE_INVITATION_BEHAVIOR_TO_FREE_FOR_ALL]))
               {
                  removeChild(this._uiButtons[GroupActionButton.TYPE_CHANGE_INVITATION_BEHAVIOR_TO_FREE_FOR_ALL]);
               }
            }
            this._invitionsBehaviour = Group.INVITATION_BEHAVIOR_BOSS_ONLY;
            _loc1_ = this.getBarButton(GroupActionButton.TYPE_CHANGE_INVITATION_BEHAVIOR_TO_BOSS_ONLY);
            _loc2_ = "label_grp_invitation_behavior_boss_only";
         }
         TooltipControl.getInstance().removeToolTip(_loc1_);
         TooltipControl.getInstance().addToolTip(_loc1_,BPLocale.getText("label_grp_change_invitation_behavior") + "\n" + BPLocale.getText(_loc2_));
         return _loc1_;
      }
      
      private function getBarButton(param1:int) : GroupActionButton
      {
         var _loc2_:GroupActionButton = this._uiButtons[param1];
         if(_loc2_ == null)
         {
            _loc2_ = this._groupUi.createGroupActionButton(param1);
            this._uiButtons[param1] = _loc2_;
            TooltipControl.getInstance().addToolTip(this._uiButtons[param1],BPLocale.getText(MgmtBtnConfig(this._buttonConfig[param1]).tooltipKey));
            if(param1 == GroupActionButton.TYPE_PING || param1 == GroupActionButton.TYPE_FOLLOW || param1 == GroupActionButton.TYPE_KICK || param1 == GroupActionButton.TYPE_PROMOTE)
            {
               _loc2_.toggle(false);
            }
         }
         return _loc2_;
      }
      
      public function get group() : Group
      {
         return this._group;
      }
      
      public function set group(param1:Group) : void
      {
         this._group = param1;
      }
      
      public function getPingButton() : GroupActionButton
      {
         return this._uiButtons[GroupActionButton.TYPE_PING];
      }
      
      public function getLeaveButton() : GroupActionButton
      {
         return this._uiButtons[GroupActionButton.TYPE_LEAVE];
      }
      
      public function getKickButton() : GroupActionButton
      {
         return this._uiButtons[GroupActionButton.TYPE_KICK];
      }
      
      public function getFollowButton() : GroupActionButton
      {
         return this._uiButtons[GroupActionButton.TYPE_FOLLOW];
      }
      
      public function getPromoteButton() : GroupActionButton
      {
         return this._uiButtons[GroupActionButton.TYPE_PROMOTE];
      }
      
      public function get groupUi() : GroupUI
      {
         return this._groupUi;
      }
      
      public function set groupUi(param1:GroupUI) : void
      {
         this._groupUi = param1;
      }
      
      public function get heroIsBoss() : Boolean
      {
         return this._heroIsBoss;
      }
      
      public function set heroIsBoss(param1:Boolean) : void
      {
         this._heroIsBoss = param1;
      }
   }
}

