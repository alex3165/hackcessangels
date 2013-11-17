package com.hackcess.angel;

import android.app.Activity;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.os.Message;
import android.os.Messenger;
import android.os.RemoteException;
import android.support.v4.app.NotificationCompat;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageButton;
import android.widget.TextView;

import java.util.logging.Handler;

public class MainActivity extends ActionBarActivity {

    private static final int REQUEST_ENABLE_BT = 1;
    private static final int REQUEST_DISCOVERABILITY = 2;
    public final String TAG = "MainActivity";
    private boolean isBound = false;
    Messenger mService = null;

    final Messenger mMessenger = new Messenger(new IncomingHandler());

    private final ServiceConnection bluetoothServiceConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            Log.d("MainActivity", "onServiceConnected");
            mService = new Messenger(service);
            isBound = true;
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            Log.d("MainActivity", "onServiceDisconnected");
            isBound = false;
        }
    };

    class IncomingHandler extends android.os.Handler {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                /*case MessengerService.MSG_SET_VALUE:
                    mCallbackText.setText("Received from service: " + msg.arg1);
                    break;*/
                default:
                    super.handleMessage(msg);
            }
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        final Context context = this;

        final ImageButton button = (ImageButton) findViewById(R.id.buttonMap);
        button.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                Intent intent = new Intent(context, AlertSliderActivity.class);
                startActivity(intent);
            }
        });
    }

    private void bindToService() {
        // Start the bluetoothservice in case it isn't running
        Intent serviceActivityIntent = new Intent(this, BluetoothService.class);
        startService(serviceActivityIntent);
        // Bind
        bindService(serviceActivityIntent, bluetoothServiceConnection, Context.BIND_AUTO_CREATE);
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (!isBound) {
            unbindService(bluetoothServiceConnection);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();

        // Get the default bluetooth adapter
        BluetoothAdapter mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        if (mBluetoothAdapter != null) {
            // Device supports Bluetooth: check if it is enabled
            if (!mBluetoothAdapter.isEnabled()) {
                // Bluetooth is not enabled: start it
                Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
                startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
            } else {
                // BT is already on, let's activate discoverability
                ensureDiscoverable();
            }
        }

    }

    private final void ensureDiscoverable() {
        BluetoothAdapter mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        if (mBluetoothAdapter.getScanMode() !=
                BluetoothAdapter.SCAN_MODE_CONNECTABLE_DISCOVERABLE) {
            Intent discoverableIntent = new
                    Intent(BluetoothAdapter.ACTION_REQUEST_DISCOVERABLE);
            discoverableIntent.putExtra(BluetoothAdapter.EXTRA_DISCOVERABLE_DURATION, 0);
            startActivityForResult(discoverableIntent, REQUEST_DISCOVERABILITY);
            Log.d(TAG, "Forced discoverability");
        } else {
            Log.d(TAG, "Device is already discoverable");
            bindToService();
        }
    }

    protected void onActivityResult(int requestCode, int resultCode,
                                    Intent data) {
        if (requestCode == REQUEST_ENABLE_BT) {
            if (resultCode == RESULT_OK) {
                // Bluetooth is ready
                ensureDiscoverable();
            }
        } else if (requestCode == REQUEST_DISCOVERABILITY) {
            if (resultCode == RESULT_OK) {
                // Device is discoverable, start service
                bindToService();
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

    private void startBroadcastAlert(int MSG_TYPE) {
        Message msg = Message.obtain(null,
                BluetoothService.MSG_START_BROADCASTING,
                MSG_TYPE,
                0);

        msg.replyTo = mMessenger;
        try {
            mService.send(msg);
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }

    public void broadcast1_Clicked(View v) {
        startBroadcastAlert(BluetoothService.MSG_TYPE_INFORMATION);
    }
    public void broadcast2_Clicked(View v) {
        startBroadcastAlert(BluetoothService.MSG_TYPE_PHYSICAL);
    }
}
