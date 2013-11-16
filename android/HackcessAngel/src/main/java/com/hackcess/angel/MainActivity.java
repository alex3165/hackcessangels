package com.hackcess.angel;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Message;
import android.os.Vibrator;
import android.support.v4.app.NotificationCompat;
import android.support.v4.app.TaskStackBuilder;
import android.support.v7.app.ActionBarActivity;
import android.support.v4.app.Fragment;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.os.Handler;
import android.widget.TextView;

public class MainActivity extends ActionBarActivity {

    public final String TAG = "MainActivity";
    private int REQUEST_ENABLE_BT = 1;
    private int NOTIFICATION_ID = 1;
    private BluetoothService bluetoothService;
    private Context context = this;

    void onAlertReceived() {
        // Notification
        NotificationCompat.Builder mBuilder =
                new NotificationCompat.Builder(context)
                        //.setSmallIcon(R.drawable.notification_icon)
                        .setContentTitle("Hackcess Angel")
                        .setContentText("Thomas a besoin d'aide!")
                        .setVibrate(new long[]{0,500,110,500,110,450,110,200,110,170,40,450,110,200,110,170,40,500});
        // Creates an explicit intent for an Activity in your app
        Intent resultIntent = new Intent(context, DetailActivity.class);
        PendingIntent resultPendingIntent =
                PendingIntent.getActivity(
                        context,
                        0,
                        resultIntent,
                        PendingIntent.FLAG_UPDATE_CURRENT
                );
        mBuilder.setContentIntent(resultPendingIntent);
        NotificationManager mNotificationManager =
                (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        // mId allows you to update the notification later on.
        mNotificationManager.notify(NOTIFICATION_ID, mBuilder.build());
    }

    void setStatusText(String text) {
        TextView textView = (TextView) findViewById(R.id.textViewInfo);
        textView.setText(text);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        bluetoothService = new BluetoothService(this);

        // Register a receiver for when a new bt device has been found during discovery
        IntentFilter filter = new IntentFilter(BluetoothDevice.ACTION_FOUND);
        registerReceiver(bluetoothService.mReceiver, filter);

        // Register for broadcasts when discovery has finished
        filter = new IntentFilter(BluetoothAdapter.ACTION_DISCOVERY_FINISHED);
        registerReceiver(bluetoothService.mReceiver, filter);

        // Get the default bluetooth adapter
        if (bluetoothService.mBluetoothAdapter != null) {
            // Device supports Bluetooth: check if it is enabled
            if (!bluetoothService.mBluetoothAdapter.isEnabled()) {
                // Bluetooth is not enabled: start it
                Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
                startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
            } else {
                // BT is already on, let's start listening immediately
                ensureDiscoverable();
                bluetoothService.startListening();
            }
        }
    }

    // Starts a thread which keeps the device discoverable
    private final void ensureDiscoverable() {
        if (bluetoothService.mBluetoothAdapter.getScanMode() !=
                BluetoothAdapter.SCAN_MODE_CONNECTABLE_DISCOVERABLE) {
            Intent discoverableIntent = new
                    Intent(BluetoothAdapter.ACTION_REQUEST_DISCOVERABLE);
            discoverableIntent.putExtra(BluetoothAdapter.EXTRA_DISCOVERABLE_DURATION, 0);
            startActivity(discoverableIntent);
            Log.d(TAG, "Forced discoverability");
        } else {
            Log.d(TAG, "Device is already discoverable");
        }
    }

    protected void onActivityResult(int requestCode, int resultCode,
                                    Intent data) {
        if (requestCode == REQUEST_ENABLE_BT) {
            if (resultCode == RESULT_OK) {
                // Bluetooth is ready, start listening
                ensureDiscoverable();
                bluetoothService.startListening();
            }
        }
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }


    public void broadcast1_Clicked(View v) {
        bluetoothService.alertMessage = "ALERT1";
        bluetoothService.startBroadcastingBluetooth();
    }
    public void broadcast2_Clicked(View v) {
        bluetoothService.alertMessage = "ALERT2";
        bluetoothService.startBroadcastingBluetooth();
    }

}
