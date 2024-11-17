import React, { useState } from "react";
import { Button } from "@mantine/core";
import { useNuiEvent } from "../hooks/useNuiEvent";
import Hud from "./Hud";
import Speedometer from "./Speed";
import Notification from "./Notification";
import { NotifyData } from "./Types";
import "./hud.scss";
import "./speed.scss";
import { isEnvBrowser } from "../utils/misc";

const App: React.FC = () => {
  const [playerData, setPlayerData] = useState({});
  const [speedometerVisible, setSpeedometerVisible] = useState(false);
  const [hudVisible, setHudVisible] = useState(false);
  const [vehicleData, setVehicleData] = useState({});
  const [notification, setNotification] = useState<NotifyData | null>(null);
  const [isNotificationVisible, setIsNotificationVisible] = useState(false); 

  useNuiEvent<any>("openHud", (data) => {
    setHudVisible(data?.Visible || false);
    setPlayerData(data?.PlayerData || {});
  });

  useNuiEvent<any>("openSpeedometer", (data) => {
    setSpeedometerVisible(data?.Visible || false);
    setVehicleData(data?.VehicleData || {});
  });

  useNuiEvent<any>("sendNoty", (data) => {
    if (data?.NotifyData) {
      setNotification(data.NotifyData);
      setIsNotificationVisible(data.Visible);
    }
  });


  return (
    <>
      <Hud visible={hudVisible} data={playerData || null} />
      <Speedometer visible={speedometerVisible} vehicleData={vehicleData || null} />
      {notification && (
        <Notification
          key={notification.NotifyID}
          notifyData={notification}
          visible={isNotificationVisible}
        />
      )}

      {isEnvBrowser() && (
        <div style={{ position: "fixed", top: 10, right: 10, zIndex: 1000 }}>
          <Button
            onClick={() => setHudVisible((prev) => !prev)}
            variant="default"
            color="orange"
            style={{ marginBottom: 10, width: 150 }}
          >
            Toggle HUD
          </Button>
          <Button
            onClick={() => setSpeedometerVisible((prev) => !prev)}
            variant="default"
            color="orange"
            style={{ width: 150 }}
          >
            Toggle Speedometer
          </Button>
          <Button
            onClick={() =>
       
              setNotification({
                Title: "Sample Notification",
                Message: "This is a simulated notification for testing.",
                Type: "error",
                Duration: 5000,
                Position: "bottom-right",
                NotifyID: `simulated-notification-${Date.now()}`,
                Effect: "line",
              })
    
            }
            variant="default"
            color="blue"
            style={{ marginTop: 10, width: 150 }}
          >
            Simulate Notification
          </Button>
        </div>
      )}
    </>
  );
};

export default App;
