package net.bigpoint.darkorbit.groupsystem
{
   public class Invitation
   {
      
      private var _inviter:GroupMember;
      
      private var _candidate:GroupMember;
      
      private var _id:int;
      
      public function Invitation()
      {
         super();
      }
      
      public function setInviter(param1:GroupMember) : void
      {
         this._inviter = param1;
      }
      
      public function getInviter() : GroupMember
      {
         return this._inviter;
      }
      
      public function setCandidate(param1:GroupMember) : void
      {
         this._candidate = param1;
      }
      
      public function getCandidate() : GroupMember
      {
         return this._candidate;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set id(param1:int) : void
      {
         this._id = param1;
      }
   }
}

