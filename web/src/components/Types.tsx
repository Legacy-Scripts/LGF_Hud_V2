export interface NotifyData {
    Title: string;
    Message: string;
    Type: "success" | "error" | "info"| "warning";
    Duration: number;
    Position: "top" |"top-left" | "top-right" | "bottom-left" | "bottom-right"| "bottom";
    NotifyID: string;
    Effect :"line" | "progress"
  }
  
  export interface NotifyTypes {
    NotifyData: NotifyData | null;
  }